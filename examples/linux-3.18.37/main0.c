#include <linux/mm.h>
#include <net/tcp.h>
#include <net/inet_common.h>
#include<klee/klee.h>
//extern int printf( const char* format, ... );
#include <asm/pgtable.h>
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/sys.h>
#include <linux/types.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/mutex.h>
#include <linux/sched.h>
#include <linux/slab.h>
#include <linux/gfp.h>
#include <linux/vmalloc.h>
#include <linux/unistd.h>
#include <linux/string.h>
#include <linux/ptrace.h>
#include <linux/errno.h>
#include <linux/ioport.h>
#include <linux/interrupt.h>
#include <linux/capability.h>
#include <linux/hrtimer.h>
#include <linux/freezer.h>
#include <linux/delay.h>
#include <linux/timer.h>
#include <linux/list.h>
#include <linux/init.h>
#include <linux/skbuff.h>
#include <linux/netdevice.h>
#include <linux/inet.h>
#include <linux/inetdevice.h>
#include <linux/rtnetlink.h>
#include <linux/if_arp.h>
#include <linux/if_vlan.h>
#include <linux/in.h>
#include <linux/ip.h>
#include <linux/ipv6.h>
#include <linux/udp.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/wait.h>
#include <linux/etherdevice.h>
#include <linux/kthread.h>
#include <linux/prefetch.h>
#include <net/net_namespace.h>
#include <net/checksum.h>
#include <net/ipv6.h>
#include <net/udp.h>
#include <net/ip6_checksum.h>
#include <net/addrconf.h>
#include <net/netns/generic.h>
#include <asm/byteorder.h>
#include <linux/rcupdate.h>
#include <linux/bitops.h>
#include <linux/io.h>
#include <linux/timex.h>
#include <linux/uaccess.h>
#include <asm/dma.h>
#include <asm/div64.h>		/* do_div */


#define MAX_BUF 128
#define VERSION	"2.74"
#define IP_NAME_SZ 32
#define MAX_MPLS_LABELS 16 /* This is the max label stack depth */
#define MPLS_STACK_BOTTOM htonl(0x00000100)

#define func_enter() pr_debug("entering %s\n", __func__);

/* Device flag bits */
#define F_IPSRC_RND   (1<<0)	/* IP-Src Random  */
#define F_IPDST_RND   (1<<1)	/* IP-Dst Random  */
#define F_UDPSRC_RND  (1<<2)	/* UDP-Src Random */
#define F_UDPDST_RND  (1<<3)	/* UDP-Dst Random */
#define F_MACSRC_RND  (1<<4)	/* MAC-Src Random */
#define F_MACDST_RND  (1<<5)	/* MAC-Dst Random */
#define F_TXSIZE_RND  (1<<6)	/* Transmit size is random */
#define F_IPV6        (1<<7)	/* Interface in IPV6 Mode */
#define F_MPLS_RND    (1<<8)	/* Random MPLS labels */
#define F_VID_RND     (1<<9)	/* Random VLAN ID */
#define F_SVID_RND    (1<<10)	/* Random SVLAN ID */
#define F_FLOW_SEQ    (1<<11)	/* Sequential flows */
#define F_IPSEC_ON    (1<<12)	/* ipsec on for flows */
#define F_QUEUE_MAP_RND (1<<13)	/* queue map Random */
#define F_QUEUE_MAP_CPU (1<<14)	/* queue map mirrors smp_processor_id() */
#define F_NODE          (1<<15)	/* Node memory alloc*/
#define F_UDPCSUM       (1<<16)	/* Include UDP checksum */
#define F_NO_TIMESTAMP  (1<<17)	/* Don't timestamp packets (default TS) */

/* Thread control flag bits */
#define T_STOP        (1<<0)	/* Stop run */
#define T_RUN         (1<<1)	/* Start run */
#define T_REMDEVALL   (1<<2)	/* Remove all devs */
#define T_REMDEV      (1<<3)	/* Remove one dev */

/* If lock -- protects updating of if_list */
#define   if_lock(t)           spin_lock(&(t->if_lock));
#define   if_unlock(t)           spin_unlock(&(t->if_lock));

/* Used to help with determining the pkts on receive */
#define PKTGEN_MAGIC 0xbe9be955
#define PG_PROC_DIR "pktgen"
#define PGCTRL	    "pgctrl"

#define MAX_CFLOWS  65536

#define VLAN_TAG_SIZE(x) ((x)->vlan_id == 0xffff ? 0 : 4)
#define SVLAN_TAG_SIZE(x) ((x)->svlan_id == 0xffff ? 0 : 4)

struct flow_state {
	__be32 cur_daddr;
	int count;
#ifdef CONFIG_XFRM
	struct xfrm_state *x;
#endif
	__u32 flags;
};

/* flow flag bits */
#define F_INIT   (1<<0)		/* flow has been initialized */

struct pktgen_dev {
	/*
	 * Try to keep frequent/infrequent used vars. separated.
	 */
	struct proc_dir_entry *entry;	/* proc file */
	struct pktgen_thread *pg_thread;/* the owner */
	struct list_head list;		/* chaining in the thread's run-queue */
	struct rcu_head	 rcu;		/* freed by RCU */

	int running;		/* if false, the test will stop */

	/* If min != max, then we will either do a linear iteration, or
	 * we will do a random selection from within the range.
	 */
	__u32 flags;
	int removal_mark;	/* non-zero => the device is marked for
				 * removal by worker thread */

	int min_pkt_size;
	int max_pkt_size;
	int pkt_overhead;	/* overhead for MPLS, VLANs, IPSEC etc */
	int nfrags;
	struct page *page;
	u64 delay;		/* nano-seconds */

	__u64 count;		/* Default No packets to send */
	__u64 sofar;		/* How many pkts we've sent so far */
	__u64 tx_bytes;		/* How many bytes we've transmitted */
	__u64 errors;		/* Errors when trying to transmit, */

	/* runtime counters relating to clone_skb */

	__u64 allocated_skbs;
	__u32 clone_count;
	int last_ok;		/* Was last skb sent?
				 * Or a failed transmit of some sort?
				 * This will keep sequence numbers in order
				 */
	ktime_t next_tx;
	ktime_t started_at;
	ktime_t stopped_at;
	u64	idle_acc;	/* nano-seconds */

	__u32 seq_num;

	int clone_skb;		/*
				 * Use multiple SKBs during packet gen.
				 * If this number is greater than 1, then
				 * that many copies of the same packet will be
				 * sent before a new packet is allocated.
				 * If you want to send 1024 identical packets
				 * before creating a new packet,
				 * set clone_skb to 1024.
				 */

	char dst_min[IP_NAME_SZ];	/* IP, ie 1.2.3.4 */
	char dst_max[IP_NAME_SZ];	/* IP, ie 1.2.3.4 */
	char src_min[IP_NAME_SZ];	/* IP, ie 1.2.3.4 */
	char src_max[IP_NAME_SZ];	/* IP, ie 1.2.3.4 */

	struct in6_addr in6_saddr;
	struct in6_addr in6_daddr;
	struct in6_addr cur_in6_daddr;
	struct in6_addr cur_in6_saddr;
	/* For ranges */
	struct in6_addr min_in6_daddr;
	struct in6_addr max_in6_daddr;
	struct in6_addr min_in6_saddr;
	struct in6_addr max_in6_saddr;

	/* If we're doing ranges, random or incremental, then this
	 * defines the min/max for those ranges.
	 */
	__be32 saddr_min;	/* inclusive, source IP address */
	__be32 saddr_max;	/* exclusive, source IP address */
	__be32 daddr_min;	/* inclusive, dest IP address */
	__be32 daddr_max;	/* exclusive, dest IP address */

	__u16 udp_src_min;	/* inclusive, source UDP port */
	__u16 udp_src_max;	/* exclusive, source UDP port */
	__u16 udp_dst_min;	/* inclusive, dest UDP port */
	__u16 udp_dst_max;	/* exclusive, dest UDP port */

	/* DSCP + ECN */
	__u8 tos;            /* six MSB of (former) IPv4 TOS
				are for dscp codepoint */
	__u8 traffic_class;  /* ditto for the (former) Traffic Class in IPv6
				(see RFC 3260, sec. 4) */

	/* MPLS */
	unsigned int nr_labels;	/* Depth of stack, 0 = no MPLS */
	__be32 labels[MAX_MPLS_LABELS];

	/* VLAN/SVLAN (802.1Q/Q-in-Q) */
	__u8  vlan_p;
	__u8  vlan_cfi;
	__u16 vlan_id;  /* 0xffff means no vlan tag */

	__u8  svlan_p;
	__u8  svlan_cfi;
	__u16 svlan_id; /* 0xffff means no svlan tag */

	__u32 src_mac_count;	/* How many MACs to iterate through */
	__u32 dst_mac_count;	/* How many MACs to iterate through */

	unsigned char dst_mac[ETH_ALEN];
	unsigned char src_mac[ETH_ALEN];

	__u32 cur_dst_mac_offset;
	__u32 cur_src_mac_offset;
	__be32 cur_saddr;
	__be32 cur_daddr;
	__u16 ip_id;
	__u16 cur_udp_dst;
	__u16 cur_udp_src;
	__u16 cur_queue_map;
	__u32 cur_pkt_size;
	__u32 last_pkt_size;

	__u8 hh[14];
	/* = {
	   0x00, 0x80, 0xC8, 0x79, 0xB3, 0xCB,

	   We fill in SRC address later
	   0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	   0x08, 0x00
	   };
	 */
	__u16 pad;		/* pad out the hh struct to an even 16 bytes */

	struct sk_buff *skb;	/* skb we are to transmit next, used for when we
				 * are transmitting the same one multiple times
				 */
	struct net_device *odev; /* The out-going device.
				  * Note that the device should have it's
				  * pg_info pointer pointing back to this
				  * device.
				  * Set when the user specifies the out-going
				  * device name (not when the inject is
				  * started as it used to do.)
				  */
	char odevname[32];
	struct flow_state *flows;
	unsigned int cflows;	/* Concurrent flows (config) */
	unsigned int lflow;		/* Flow length  (config) */
	unsigned int nflows;	/* accumulated flows (stats) */
	unsigned int curfl;		/* current sequenced flow (state)*/

	u16 queue_map_min;
	u16 queue_map_max;
	__u32 skb_priority;	/* skb priority field */
	unsigned int burst;	/* number of duplicated packets to burst */
	int node;               /* Memory node */

#ifdef CONFIG_XFRM
	__u8	ipsmode;		/* IPSEC mode (config) */
	__u8	ipsproto;		/* IPSEC type (config) */
	__u32	spi;
	struct dst_entry dst;
	struct dst_ops dstops;
#endif
	char result[512];
};

struct pktgen_hdr {
	__be32 pgh_magic;
	__be32 seq_num;
	__be32 tv_sec;
	__be32 tv_usec;
};


static int pg_net_id __read_mostly;

struct pktgen_net {
	struct net		*net;
	struct proc_dir_entry	*proc_dir;
	struct list_head	pktgen_threads;
	bool			pktgen_exiting;
};

struct pktgen_thread {
	spinlock_t if_lock;		/* for list of devices */
	struct list_head if_list;	/* All device here */
	struct list_head th_list;
	struct task_struct *tsk;
	char result[512];

	/* Field for thread to receive "posted" events terminate,
	   stop ifs etc. */

	u32 control;
	int cpu;

	wait_queue_head_t queue;
	struct completion start_done;
	struct pktgen_net *net;
};

#define REMOVE 1
#define FIND   0

static const char version[] =
	"Packet Generator for packet performance testing. "
	"Version: " VERSION "\n";

static int pktgen_remove_device(struct pktgen_thread *t, struct pktgen_dev *i);
static int pktgen_add_device(struct pktgen_thread *t, const char *ifname);
static struct pktgen_dev *pktgen_find_dev(struct pktgen_thread *t,
					  const char *ifname, bool exact);
static int pktgen_device_event(struct notifier_block *, unsigned long, void *);
static void pktgen_run_all_threads(struct pktgen_net *pn);
static void pktgen_reset_all_threads(struct pktgen_net *pn);
static void pktgen_stop_all_threads_ifs(struct pktgen_net *pn);

static void pktgen_stop(struct pktgen_thread *t);
static void pktgen_clear_counters(struct pktgen_dev *pkt_dev);

/* Module parameters, defaults. */
static int pg_count_d __read_mostly = 1000;
static int pg_delay_d __read_mostly;
static int pg_clone_skb_d  __read_mostly;
static int debug  __read_mostly;

static DEFINE_MUTEX(pktgen_thread_lock);


/*
 * /proc handling functions
 *
 */


static int hex32_arg(const char __user *user_buffer, unsigned long maxlen,
		     __u32 *num)
{
	int i = 0;
	*num = 0;

	for (; i < maxlen; i++) {
		int value;
		char c;
		*num <<= 4;
		if (get_user(c, &user_buffer[i]))
			return -EFAULT;
		value = hex_to_bin(c);
		if (value >= 0)
			*num |= value;
		else
			break;
	}
	return i;
}

static int count_trail_chars(const char __user * user_buffer,
			     unsigned int maxlen)
{
	int i;

	for (i = 0; i < maxlen; i++) {
		char c;
		if (get_user(c, &user_buffer[i]))
			return -EFAULT;
		switch (c) {
		case '\"':
		case '\n':
		case '\r':
		case '\t':
		case ' ':
		case '=':
			break;
		default:
			goto done;
		}
	}
done:
	return i;
}
void ip_send_check(struct iphdr *iph){
	iph->check = 0;
}
static inline void set_pkt_overhead(struct pktgen_dev *pkt_dev)
{
	pkt_dev->pkt_overhead = 0;
	pkt_dev->pkt_overhead += pkt_dev->nr_labels*sizeof(u32);
	pkt_dev->pkt_overhead += VLAN_TAG_SIZE(pkt_dev);
	pkt_dev->pkt_overhead += SVLAN_TAG_SIZE(pkt_dev);
}
static inline __be16 build_tci(unsigned int id, unsigned int cfi,
			       unsigned int prio)
{
	return htons(id | (cfi << 12) | (prio << 13));
}
static inline int f_seen(const struct pktgen_dev *pkt_dev, int flow)
{
	return !!(pkt_dev->flows[flow].flags & F_INIT);
}
static inline int f_pick(struct pktgen_dev *pkt_dev)
{
	int flow = pkt_dev->curfl;

	if (pkt_dev->flags & F_FLOW_SEQ) {
		if (pkt_dev->flows[flow].count >= pkt_dev->lflow) {
			/* reset time */
			pkt_dev->flows[flow].count = 0;
			pkt_dev->flows[flow].flags = 0;
			pkt_dev->curfl += 1;
			if (pkt_dev->curfl >= pkt_dev->cflows)
				pkt_dev->curfl = 0; /*reset */
		}
	} else {
		flow = prandom_u32() % pkt_dev->cflows;
		pkt_dev->curfl = flow;

		if (pkt_dev->flows[flow].count > pkt_dev->lflow) {
			pkt_dev->flows[flow].count = 0;
			pkt_dev->flows[flow].flags = 0;
		}
	}

	return pkt_dev->curfl;
}
static void mod_cur_headers(struct pktgen_dev *pkt_dev)
{
	__u32 imn;
	__u32 imx;
	int flow = 0;

	if (pkt_dev->cflows)
		flow = f_pick(pkt_dev);

	/*  Deal with source MAC */
	if (pkt_dev->src_mac_count > 1) {
		__u32 mc;
		__u32 tmp;

		if (pkt_dev->flags & F_MACSRC_RND)
			mc = prandom_u32() % pkt_dev->src_mac_count;
		else {
			mc = pkt_dev->cur_src_mac_offset++;
			if (pkt_dev->cur_src_mac_offset >=
			    pkt_dev->src_mac_count)
				pkt_dev->cur_src_mac_offset = 0;
		}

		tmp = pkt_dev->src_mac[5] + (mc & 0xFF);
		pkt_dev->hh[11] = tmp;
		tmp = (pkt_dev->src_mac[4] + ((mc >> 8) & 0xFF) + (tmp >> 8));
		pkt_dev->hh[10] = tmp;
		tmp = (pkt_dev->src_mac[3] + ((mc >> 16) & 0xFF) + (tmp >> 8));
		pkt_dev->hh[9] = tmp;
		tmp = (pkt_dev->src_mac[2] + ((mc >> 24) & 0xFF) + (tmp >> 8));
		pkt_dev->hh[8] = tmp;
		tmp = (pkt_dev->src_mac[1] + (tmp >> 8));
		pkt_dev->hh[7] = tmp;
	}

	/*  Deal with Destination MAC */
	if (pkt_dev->dst_mac_count > 1) {
		__u32 mc;
		__u32 tmp;

		if (pkt_dev->flags & F_MACDST_RND)
			mc = prandom_u32() % pkt_dev->dst_mac_count;

		else {
			mc = pkt_dev->cur_dst_mac_offset++;
			if (pkt_dev->cur_dst_mac_offset >=
			    pkt_dev->dst_mac_count) {
				pkt_dev->cur_dst_mac_offset = 0;
			}
		}

		tmp = pkt_dev->dst_mac[5] + (mc & 0xFF);
		pkt_dev->hh[5] = tmp;
		tmp = (pkt_dev->dst_mac[4] + ((mc >> 8) & 0xFF) + (tmp >> 8));
		pkt_dev->hh[4] = tmp;
		tmp = (pkt_dev->dst_mac[3] + ((mc >> 16) & 0xFF) + (tmp >> 8));
		pkt_dev->hh[3] = tmp;
		tmp = (pkt_dev->dst_mac[2] + ((mc >> 24) & 0xFF) + (tmp >> 8));
		pkt_dev->hh[2] = tmp;
		tmp = (pkt_dev->dst_mac[1] + (tmp >> 8));
		pkt_dev->hh[1] = tmp;
	}

	if (pkt_dev->flags & F_MPLS_RND) {
		unsigned int i;
		for (i = 0; i < pkt_dev->nr_labels; i++)
			if (pkt_dev->labels[i] & MPLS_STACK_BOTTOM)
				pkt_dev->labels[i] = MPLS_STACK_BOTTOM |
					     ((__force __be32)prandom_u32() &
						      htonl(0x000fffff));
	}

	if ((pkt_dev->flags & F_VID_RND) && (pkt_dev->vlan_id != 0xffff)) {
		pkt_dev->vlan_id = prandom_u32() & (4096 - 1);
	}

	if ((pkt_dev->flags & F_SVID_RND) && (pkt_dev->svlan_id != 0xffff)) {
		pkt_dev->svlan_id = prandom_u32() & (4096 - 1);
	}

	if (pkt_dev->udp_src_min < pkt_dev->udp_src_max) {
		if (pkt_dev->flags & F_UDPSRC_RND)
			pkt_dev->cur_udp_src = prandom_u32() %
				(pkt_dev->udp_src_max - pkt_dev->udp_src_min)
				+ pkt_dev->udp_src_min;

		else {
			pkt_dev->cur_udp_src++;
			if (pkt_dev->cur_udp_src >= pkt_dev->udp_src_max)
				pkt_dev->cur_udp_src = pkt_dev->udp_src_min;
		}
	}

	if (pkt_dev->udp_dst_min < pkt_dev->udp_dst_max) {
		if (pkt_dev->flags & F_UDPDST_RND) {
			pkt_dev->cur_udp_dst = prandom_u32() %
				(pkt_dev->udp_dst_max - pkt_dev->udp_dst_min)
				+ pkt_dev->udp_dst_min;
		} else {
			pkt_dev->cur_udp_dst++;
			if (pkt_dev->cur_udp_dst >= pkt_dev->udp_dst_max)
				pkt_dev->cur_udp_dst = pkt_dev->udp_dst_min;
		}
	}

	if (!(pkt_dev->flags & F_IPV6)) {

		imn = ntohl(pkt_dev->saddr_min);
		imx = ntohl(pkt_dev->saddr_max);
		if (imn < imx) {
			__u32 t;
			if (pkt_dev->flags & F_IPSRC_RND)
				t = prandom_u32() % (imx - imn) + imn;
			else {
				t = ntohl(pkt_dev->cur_saddr);
				t++;
				if (t > imx)
					t = imn;

			}
			pkt_dev->cur_saddr = htonl(t);
		}

		if (pkt_dev->cflows && f_seen(pkt_dev, flow)) {
			pkt_dev->cur_daddr = pkt_dev->flows[flow].cur_daddr;
		} else {
			imn = ntohl(pkt_dev->daddr_min);
			imx = ntohl(pkt_dev->daddr_max);
			if (imn < imx) {
				__u32 t;
				__be32 s;
				if (pkt_dev->flags & F_IPDST_RND) {

					do {
						t = prandom_u32() %
							(imx - imn) + imn;
						s = htonl(t);
					} while (ipv4_is_loopback(s) ||
						ipv4_is_multicast(s) ||
						ipv4_is_lbcast(s) ||
						ipv4_is_zeronet(s) ||
						ipv4_is_local_multicast(s));
					pkt_dev->cur_daddr = s;
				} else {
					t = ntohl(pkt_dev->cur_daddr);
					t++;
					if (t > imx) {
						t = imn;
					}
					pkt_dev->cur_daddr = htonl(t);
				}
			}
			if (pkt_dev->cflows) {
				pkt_dev->flows[flow].flags |= F_INIT;
				pkt_dev->flows[flow].cur_daddr =
				    pkt_dev->cur_daddr;
				pkt_dev->nflows++;
			}
		}
	} else {		/* IPV6 * */

		if (!ipv6_addr_any(&pkt_dev->min_in6_daddr)) {
			int i;

			/* Only random destinations yet */

			for (i = 0; i < 4; i++) {
				pkt_dev->cur_in6_daddr.s6_addr32[i] =
				    (((__force __be32)prandom_u32() |
				      pkt_dev->min_in6_daddr.s6_addr32[i]) &
				     pkt_dev->max_in6_daddr.s6_addr32[i]);
			}
		}
	}

	if (pkt_dev->min_pkt_size < pkt_dev->max_pkt_size) {
		__u32 t;
		if (pkt_dev->flags & F_TXSIZE_RND) {
			t = prandom_u32() %
				(pkt_dev->max_pkt_size - pkt_dev->min_pkt_size)
				+ pkt_dev->min_pkt_size;
		} else {
			t = pkt_dev->cur_pkt_size + 1;
			if (t > pkt_dev->max_pkt_size)
				t = pkt_dev->min_pkt_size;
		}
		pkt_dev->cur_pkt_size = t;
	}


	pkt_dev->flows[flow].count++;
}


static long num_arg(const char __user *user_buffer, unsigned long maxlen,
				unsigned long *num)
{
	int i;
	*num = 0;

	for (i = 0; i < maxlen; i++) {
		char c;
		if (get_user(c, &user_buffer[i]))
			return -EFAULT;
		if ((c >= '0') && (c <= '9')) {
			*num *= 10;
			*num += c - '0';
		} else
			break;
	}
	return i;
}

static int strn_len(const char __user * user_buffer, unsigned int maxlen)
{
	int i;

	for (i = 0; i < maxlen; i++) {
		char c;
		if (get_user(c, &user_buffer[i]))
			return -EFAULT;
		switch (c) {
		case '\"':
		case '\n':
		case '\r':
		case '\t':
		case ' ':
			goto done_str;
		default:
			break;
		}
	}
done_str:
	return i;
}

static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
				int datalen)
{
	struct timeval timestamp;
	struct pktgen_hdr *pgh;

	pgh = (struct pktgen_hdr *)skb_put(skb, sizeof(*pgh));
	datalen -= sizeof(*pgh);

	if (pkt_dev->nfrags <= 0) {
		memset(skb_put(skb, datalen), 0, datalen);
	} else {
		int frags = pkt_dev->nfrags;
		int i, len;
		int frag_len;


		if (frags > MAX_SKB_FRAGS)
			frags = MAX_SKB_FRAGS;
		len = datalen - frags * PAGE_SIZE;
		if (len > 0) {
			memset(skb_put(skb, len), 0, len);
			datalen = frags * PAGE_SIZE;
		}

		i = 0;
		frag_len = (datalen/frags) < PAGE_SIZE ?
			   (datalen/frags) : PAGE_SIZE;
		while (datalen > 0) {
			if (unlikely(!pkt_dev->page)) {
				int node = numa_node_id();

				if (pkt_dev->node >= 0 && (pkt_dev->flags & F_NODE))
					node = pkt_dev->node;
				pkt_dev->page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
				if (!pkt_dev->page)
					break;
			}
			get_page(pkt_dev->page);
			skb_frag_set_page(skb, i, pkt_dev->page);
			skb_shinfo(skb)->frags[i].page_offset = 0;
			/*last fragment, fill rest of data*/
			if (i == (frags - 1))
				skb_frag_size_set(&skb_shinfo(skb)->frags[i],
				    (datalen < PAGE_SIZE ? datalen : PAGE_SIZE));
			else
				skb_frag_size_set(&skb_shinfo(skb)->frags[i], frag_len);
			datalen -= skb_frag_size(&skb_shinfo(skb)->frags[i]);
			skb->len += skb_frag_size(&skb_shinfo(skb)->frags[i]);
			skb->data_len += skb_frag_size(&skb_shinfo(skb)->frags[i]);
			i++;
			skb_shinfo(skb)->nr_frags = i;
		}
	}

	/* Stamp the time, and sequence number,
	 * convert them to network byte order
	 */
	pgh->pgh_magic = htonl(PKTGEN_MAGIC);
	pgh->seq_num = htonl(pkt_dev->seq_num);

	if (pkt_dev->flags & F_NO_TIMESTAMP) {
		pgh->tv_sec = 0;
		pgh->tv_usec = 0;
	} else {
		do_gettimeofday(&timestamp);
		pgh->tv_sec = htonl(timestamp.tv_sec);
		pgh->tv_usec = htonl(timestamp.tv_usec);
	}
}

static struct sk_buff *pktgen_alloc_skb(struct net_device *dev,
					struct pktgen_dev *pkt_dev,
					unsigned int extralen)
{
	struct sk_buff *skb = NULL;
	unsigned int size = pkt_dev->cur_pkt_size + 64 + extralen +
			    pkt_dev->pkt_overhead;

	if (pkt_dev->flags & F_NODE) {
		int node = pkt_dev->node >= 0 ? pkt_dev->node : numa_node_id();

		skb = __alloc_skb(NET_SKB_PAD + size, GFP_NOWAIT, 0, node);
		if (likely(skb)) {
			skb_reserve(skb, NET_SKB_PAD);
			skb->dev = dev;
		}
	} else {
		 skb = __netdev_alloc_skb(dev, size, GFP_NOWAIT);
	}

	return skb;
}

static struct sk_buff *fill_packet_ipv4(struct net_device *odev,
					struct pktgen_dev *pkt_dev)
{
	struct sk_buff *skb = NULL;
	__u8 *eth;
	struct tcphdr *tcph;
	int datalen, iplen;
	struct iphdr *iph;
	__be16 protocol = htons(ETH_P_IP);
	__be32 *mpls;
	__be16 *vlan_tci = NULL;                 /* Encapsulates priority and VLAN ID */
	__be16 *vlan_encapsulated_proto = NULL;  /* packet type ID field (or len) for VLAN tag */
	__be16 *svlan_tci = NULL;                /* Encapsulates priority and SVLAN ID */
	__be16 *svlan_encapsulated_proto = NULL; /* packet type ID field (or len) for SVLAN tag */
	u16 queue_map;

	if (pkt_dev->nr_labels)
		protocol = htons(ETH_P_MPLS_UC);

	if (pkt_dev->vlan_id != 0xffff)
		protocol = htons(ETH_P_8021Q);

	/* Update any of the values, used when we're incrementing various
	 * fields.
	 */
	mod_cur_headers(pkt_dev);
	queue_map = pkt_dev->cur_queue_map;

	datalen = (odev->hard_header_len + 16) & ~0xf;

	skb = pktgen_alloc_skb(odev, pkt_dev, datalen);
	if (!skb) {
		sprintf(pkt_dev->result, "No memory");
		return NULL;
	}

	prefetchw(skb->data);
	skb_reserve(skb, datalen);

	/*  Reserve for ethernet and IP header  */
	eth = (__u8 *) skb_push(skb, 14);
	mpls = (__be32 *)skb_put(skb, pkt_dev->nr_labels*sizeof(__u32));
		if (pkt_dev->vlan_id != 0xffff) {
		if (pkt_dev->svlan_id != 0xffff) {
			svlan_tci = (__be16 *)skb_put(skb, sizeof(__be16));
			*svlan_tci = build_tci(pkt_dev->svlan_id,
					       pkt_dev->svlan_cfi,
					       pkt_dev->svlan_p);
			svlan_encapsulated_proto = (__be16 *)skb_put(skb, sizeof(__be16));
			*svlan_encapsulated_proto = htons(ETH_P_8021Q);
		}
		vlan_tci = (__be16 *)skb_put(skb, sizeof(__be16));
		*vlan_tci = build_tci(pkt_dev->vlan_id,
				      pkt_dev->vlan_cfi,
				      pkt_dev->vlan_p);
		vlan_encapsulated_proto = (__be16 *)skb_put(skb, sizeof(__be16));
		*vlan_encapsulated_proto = htons(ETH_P_IP);
	}

	skb_set_mac_header(skb, 0);
	skb_set_network_header(skb, skb->len);
	iph = (struct iphdr *) skb_put(skb, sizeof(struct iphdr));

	skb_set_transport_header(skb, skb->len);
	tcph = (struct tcphdr *) skb_put(skb, sizeof(struct tcphdr));
	skb_set_queue_mapping(skb, queue_map);
	skb->priority = pkt_dev->skb_priority;

	memcpy(eth, pkt_dev->hh, 12);
	*(__be16 *) & eth[12] = protocol;

	/* Eth + IPh + UDPh + mpls */
	datalen = pkt_dev->cur_pkt_size - 14 - 20 - 8 -
		  pkt_dev->pkt_overhead;
	if (datalen < 0 || datalen < sizeof(struct pktgen_hdr))
		datalen = sizeof(struct pktgen_hdr);

	tcph->source = htons(pkt_dev->cur_udp_src);
	tcph->dest = htons(pkt_dev->cur_udp_dst);
	//tcph->len = htons(datalen + 8);	/* DATA + tcphdr */
	tcph->check = 0;

	iph->ihl = 5;
	iph->version = 4;
	iph->ttl = 32;
	iph->tos = pkt_dev->tos;
	iph->protocol = IPPROTO_UDP;	/* UDP */
	iph->saddr = pkt_dev->cur_saddr;
	iph->daddr = pkt_dev->cur_daddr;
	iph->id = htons(pkt_dev->ip_id);
	pkt_dev->ip_id++;
	iph->frag_off = 0;
	iplen = 20 + 8 + datalen;
	iph->tot_len = htons(iplen);
	ip_send_check(iph);
	skb->protocol = protocol;
	skb->dev = odev;
	skb->pkt_type = PACKET_HOST;

	pktgen_finalize_skb(pkt_dev, skb, datalen);

	if (!(pkt_dev->flags & F_UDPCSUM)) {
		skb->ip_summed = CHECKSUM_NONE;
	} else if (odev->features & NETIF_F_V4_CSUM) {
		skb->ip_summed = CHECKSUM_PARTIAL;
		skb->csum = 0;
		udp4_hwcsum(skb, iph->saddr, iph->daddr);
	} else {
		__wsum csum = skb_checksum(skb, skb_transport_offset(skb), datalen + 8, 0);

		/* add protocol-dependent pseudo-header */
		tcph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
						datalen + 8, IPPROTO_UDP, csum);

		if (tcph->check == 0)
			tcph->check = CSUM_MANGLED_0;
	}

	return skb;
}

static struct sk_buff *fill_packet_ipv6(struct net_device *odev,
					struct pktgen_dev *pkt_dev)
{
	struct sk_buff *skb = NULL;
	__u8 *eth;
	struct tcphdr *tcph;
	int datalen, udplen;
	struct ipv6hdr *iph;
	__be16 protocol = htons(ETH_P_IPV6);
	__be32 *mpls;
	__be16 *vlan_tci = NULL;                 /* Encapsulates priority and VLAN ID */
	__be16 *vlan_encapsulated_proto = NULL;  /* packet type ID field (or len) for VLAN tag */
	__be16 *svlan_tci = NULL;                /* Encapsulates priority and SVLAN ID */
	__be16 *svlan_encapsulated_proto = NULL; /* packet type ID field (or len) for SVLAN tag */
	u16 queue_map;

	if (pkt_dev->nr_labels)
		protocol = htons(ETH_P_MPLS_UC);

	if (pkt_dev->vlan_id != 0xffff)
		protocol = htons(ETH_P_8021Q);

	/* Update any of the values, used when we're incrementing various
	 * fields.
	 */
	mod_cur_headers(pkt_dev);
	queue_map = pkt_dev->cur_queue_map;

	skb = pktgen_alloc_skb(odev, pkt_dev, 16);
	if (!skb) {
		sprintf(pkt_dev->result, "No memory");
		return NULL;
	}

	prefetchw(skb->data);
	skb_reserve(skb, 16);

	/*  Reserve for ethernet and IP header  */
	eth = (__u8 *) skb_push(skb, 14);
	mpls = (__be32 *)skb_put(skb, pkt_dev->nr_labels*sizeof(__u32));
		if (pkt_dev->vlan_id != 0xffff) {
		if (pkt_dev->svlan_id != 0xffff) {
			svlan_tci = (__be16 *)skb_put(skb, sizeof(__be16));
			*svlan_tci = build_tci(pkt_dev->svlan_id,
					       pkt_dev->svlan_cfi,
					       pkt_dev->svlan_p);
			svlan_encapsulated_proto = (__be16 *)skb_put(skb, sizeof(__be16));
			*svlan_encapsulated_proto = htons(ETH_P_8021Q);
		}
		vlan_tci = (__be16 *)skb_put(skb, sizeof(__be16));
		*vlan_tci = build_tci(pkt_dev->vlan_id,
				      pkt_dev->vlan_cfi,
				      pkt_dev->vlan_p);
		vlan_encapsulated_proto = (__be16 *)skb_put(skb, sizeof(__be16));
		*vlan_encapsulated_proto = htons(ETH_P_IPV6);
	}

	skb_set_mac_header(skb, 0);
	skb_set_network_header(skb, skb->len);
	iph = (struct ipv6hdr *) skb_put(skb, sizeof(struct ipv6hdr));

	skb_set_transport_header(skb, skb->len);
	tcph = (struct tcphdr *) skb_put(skb, sizeof(struct tcphdr));
	skb_set_queue_mapping(skb, queue_map);
	skb->priority = pkt_dev->skb_priority;

	memcpy(eth, pkt_dev->hh, 12);
	*(__be16 *) &eth[12] = protocol;

	/* Eth + IPh + UDPh + mpls */
	datalen = pkt_dev->cur_pkt_size - 14 -
		  sizeof(struct ipv6hdr) - sizeof(struct tcphdr) -
		  pkt_dev->pkt_overhead;

	if (datalen < 0 || datalen < sizeof(struct pktgen_hdr)) {
		datalen = sizeof(struct pktgen_hdr);
	}

	udplen = datalen + sizeof(struct tcphdr);
	tcph->source = htons(pkt_dev->cur_udp_src);
	tcph->dest = htons(pkt_dev->cur_udp_dst);
	tcph->check = 0;

	*(__be32 *) iph = htonl(0x60000000);	/* Version + flow */

	if (pkt_dev->traffic_class) {
		/* Version + traffic class + flow (0) */
		*(__be32 *)iph |= htonl(0x60000000 | (pkt_dev->traffic_class << 20));
	}

	iph->hop_limit = 32;

	iph->payload_len = htons(udplen);
	iph->nexthdr = IPPROTO_UDP;

	iph->daddr = pkt_dev->cur_in6_daddr;
	iph->saddr = pkt_dev->cur_in6_saddr;

	skb->protocol = protocol;
	skb->dev = odev;
	skb->pkt_type = PACKET_HOST;

	pktgen_finalize_skb(pkt_dev, skb, datalen);

	if (!(pkt_dev->flags & F_UDPCSUM)) {
		skb->ip_summed = CHECKSUM_NONE;
	} else if (odev->features & NETIF_F_V6_CSUM) {
		skb->ip_summed = CHECKSUM_PARTIAL;
		skb->csum_start = skb_transport_header(skb) - skb->head;
		skb->csum_offset = offsetof(struct tcphdr, check);
		tcph->check = ~csum_ipv6_magic(&iph->saddr, &iph->daddr, udplen, IPPROTO_UDP, 0);
	} else {
		__wsum csum = skb_checksum(skb, skb_transport_offset(skb), udplen, 0);

		/* add protocol-dependent pseudo-header */
		tcph->check = csum_ipv6_magic(&iph->saddr, &iph->daddr, udplen, IPPROTO_UDP, csum);

		if (tcph->check == 0)
			tcph->check = CSUM_MANGLED_0;
	}

	return skb;
}

static struct sk_buff *fill_packet(struct net_device *odev,
				   struct pktgen_dev *pkt_dev)
{
	if (pkt_dev->flags & F_IPV6)
		return fill_packet_ipv6(odev, pkt_dev);
	else
		return fill_packet_ipv4(odev, pkt_dev);
}

static void pktgen_clear_counters(struct pktgen_dev *pkt_dev)
{
	pkt_dev->seq_num = 1;
	pkt_dev->idle_acc = 0;
	pkt_dev->sofar = 0;
	pkt_dev->tx_bytes = 0;
	pkt_dev->errors = 0;
}



//extern int       atoi(const char *);
/*char  _text[128];
char __kprobes_text_start[128],__kprobes_text_end[128],__entry_text_end[128],__entry_text_start[128],__init_begin[128],__init_end[128],__end_rodata_hpage_align[128],__start_rodata[128],__end_rodata[128],_sdata[128],_stext[128],__vvar_page[128],_sinittext[128],_einittext[128],__sched_text_end[128],__sched_text_start[128],__start___ksymtab[128],__stop___ksymtab[128],__start_builtin_fw[128],__end_builtin_fw[128],__setup_start[128],
	 __setup_end[128],__initcall_start[128],__initcall0_start[128],__initramfs_start[128],__brk_limit[128],__bss_stop[128],__brk_base[128],__iommu_table[128],__iommu_table_end[128];
struct alt_instr __alt_instructions[8],__alt_instructions_end[8];
*/
struct faked_kmem_cache{
	size_t object_size;
	unsigned long flags;
};
extern struct kmem_cache *skbuff_fclone_cache;
extern void * malloc(int size);
struct kmem_cache *faked_kmem_cache_create(const char * name, size_t size, size_t align,unsigned long flags, void (*ctor)(void *)){
	struct faked_kmem_cache* s=malloc(sizeof(struct faked_kmem_cache));
	s->object_size=size;
	s->flags=flags;
	return s;
}
void * faked_kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t gfp, int node){
	struct faked_kmem_cache* s=(struct faked_kmem_cache*)cachep;
	return malloc(s->object_size);
}
void *faked___kmalloc(size_t size, gfp_t flags){
	return malloc(size);
}
#define MAXRESERVED 10
unsigned long saved_addr[MAXRESERVED];
int saved_count;
size_t saved_size[MAXRESERVED];
void *faked___kmalloc_reserve(size_t size, gfp_t flags, int node){
	void * result= malloc(size);
	saved_addr[saved_count]=result;
	saved_size[saved_count]=size;
	saved_count++;
	return result;
}
size_t faked_ksize(const void *object){
	for(int i=0;i<saved_count;i++){
		if(object==saved_addr[i])
		  return saved_size[i];
	}
	return 0;
}
void faked_skb_init(void){
	 skbuff_head_cache = kmem_cache_create("skbuff_head_cache",  sizeof(struct sk_buff), 0,SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
	 skbuff_fclone_cache = kmem_cache_create("skbuff_fclone_cache",
				  sizeof(struct sk_buff_fclones),
				    0,
					 SLAB_HWCACHE_ALIGN|SLAB_PANIC,
					  NULL);
}
void *faked_kmem_cache_alloc(struct kmem_cache *cachep, int flags){
	struct faked_kmem_cache* s=(struct faked_kmem_cache*)cachep;
	return malloc(s->object_size);
}
extern int printf( const char* format, ... );
extern void gettimeofday(struct timeval *tv,int);
void faked_do_gettimeofday(struct timeval *tv){
	 gettimeofday(tv, 0);
}
unsigned faked_do_csum(const unsigned char *buff, unsigned len){
	return len;
}
__wsum faked_csum_partial(const void *buff, int len, __wsum wsum){
	return (__wsum)len;
}
void faked_local_bh_enable(void){
	do{}while(0);
}
void faked_local_bh_disable(void){
	do{}while(0);
}
struct thread_info * faked_current_thread_info(void){
	return NULL;
}

struct pktgen_dev * create_pkgdev(int pg_delay_d,int sofar,int pg_clone_skb_d){
	struct pktgen_dev *pkt_dev;
	pkt_dev =malloc(sizeof(struct pktgen_dev));
	memset(pkt_dev,0,sizeof(struct pktgen_dev));
	const char * ifname="hi@"; 
	strcpy(pkt_dev->odevname, ifname);
	int node = cpu_to_node(-1);
	pkt_dev->flows =(struct flow_state*)malloc(MAX_CFLOWS * sizeof(struct flow_state));
	pkt_dev->removal_mark = 0;
	pkt_dev->nfrags = 0;
	pkt_dev->delay = pg_delay_d;
	pkt_dev->count = 1;
	pkt_dev->sofar = sofar;
	pkt_dev->udp_src_min = 9;       /* si*/
	pkt_dev->udp_src_max = 9;
	pkt_dev->udp_dst_min = 9;
	pkt_dev->udp_dst_max = 9;

	pkt_dev->vlan_p = 0;
	pkt_dev->vlan_cfi = 0;
	pkt_dev->vlan_id = 0xffff;

	pkt_dev->svlan_p = 0;
	pkt_dev->svlan_cfi = 0;
	pkt_dev->svlan_id = 0xffff;
	pkt_dev->burst = 1;
	pkt_dev->node = -1;
	pg_clone_skb_d=1;
	pkt_dev->clone_skb = pg_clone_skb_d;
		pkt_dev->cur_pkt_size=14 + 20 + 8;

	pkt_dev->flags=F_NODE|F_FLOW_SEQ;
	set_pkt_overhead(pkt_dev);
	return pkt_dev;
}
void init_env(){
	klee_alias_function("kmem_cache_create","faked_kmem_cache_create");
	klee_alias_function("kmem_cache_alloc","faked_kmem_cache_alloc");
	klee_alias_function("kmem_cache_alloc_node","faked_kmem_cache_alloc_node");
	klee_alias_function("__kmalloc","faked___kmalloc");
	klee_alias_function("__kmalloc_reserve","faked___kmalloc_reserve");
	klee_alias_function("skb_init","faked_skb_init");
	klee_alias_function("ksize","faked_ksize");
	klee_alias_function("do_gettimeofday","faked_do_gettimeofday");	
	klee_alias_function("csum_partial","faked_csum_partial");
	klee_alias_function("local_bh_enable","faked_local_bh_enable");
	klee_alias_function("local_bh_disable","faked_local_bh_disable");
klee_alias_function("current_thread_info","faked_current_thread_info");

}
void init_skb2(struct sk_buff* skb,struct sock* sk){
	skb->next=NULL;
	skb->prev=NULL;
	sk->sk_state = TCP_ESTABLISHED;
	skb->sk=sk;
	skb->pkt_type = PACKET_HOST;	
	int len;
	klee_make_symbolic(&len,sizeof(int),"len");
	skb->len=len;
	ktime_t tstamp;
	klee_make_symbolic(&tstamp,sizeof( ktime_t),"tstamp");
	skb->tstamp=tstamp;
	skb->dev=NULL;
	char cb[48];	
	klee_make_symbolic(cb,48,"tcp_skb_cb");
	memcpy(skb->cb,cb,48);
	struct tcphdr  th;
	klee_make_symbolic(&th,sizeof(th),"th");
	memcpy(skb_transport_header(skb),&th,sizeof(th));
	skb->_skb_refdst=(struct dst_entry*)malloc(sizeof(struct dst_entry));
	sk->sk_rx_dst=(struct dst_entry *)(skb->_skb_refdst & SKB_DST_PTRMASK);
tcp_prot.init(sk);
}
void init_net2(void){
	struct tcp_mib* tcp_mibs=malloc(sizeof(struct tcp_mib));
	klee_make_symbolic(tcp_mibs,sizeof(struct tcp_mib),"tcp_mibs");
	(&init_net)->mib.tcp_statistics=tcp_mibs;
}
#undef current
#define current NULL
#undef  test_bit(nr, addr) 
#define test_bit(nr, addr) (((1UL << (nr & 31)) & (addr[nr >> 5])) != 0)
int tcp_main()//(int argc,char** argv)
{
	init_env();
	init_net2();
	printf("%s",sock_net(NULL));
	printf("%s",(&init_net)->mib.tcp_statistics);


	int pg_count_d = 1000;
	int pg_delay_d ;
	int pg_clone_skb_d=1,sofar;
	saved_count=0;
	unsigned int len;
	struct tcp_sock* sk;
	struct sk_buff* skb;
	struct tcphdr* th;
	struct pktgen_dev *pkt_dev;
	int family=AF_INET;
	int type=SOCK_STREAM;
	int protocol=0;
	struct socket *sock;
	int sock_size=sizeof(struct tcp_sock);
	int sk_size=sizeof(struct sk_buff);
	int th_size=sizeof(struct tcphdr);
	char buff[MAX_BUF];
	int offset;
	struct dst_entry sk_rx_dst;
	sock_size=sock_size>sizeof(struct sock)?sock_size:sizeof(struct sock);
	sk=malloc(sock_size);
	skb=malloc(sk_size);
	th=malloc(th_size);

	klee_make_symbolic(sk,sock_size,"sk");
	klee_make_symbolic(skb,sk_size,"skb");
	//	klee_make_symbolic(th,th_size,"th");

	klee_make_symbolic(buff,MAX_BUF,"buf");
	klee_make_symbolic(&offset,sizeof(offset),"offset");

	klee_make_symbolic(&sofar,sizeof(int),"sofar");
	klee_make_symbolic(&pg_delay_d,sizeof(int),"delay");
	//	tcp_set_state(&sk,len);
	//tcp_v4_rcv(&skb);	

	printf("\n tcphdr=%d",sizeof(struct  tcphdr));

	
	pkt_dev=create_pkgdev(pg_delay_d,sofar,pg_clone_skb_d);
	struct net_device odevv,* odev;
	odevv.hard_header_len=0;
	odevv.needed_headroom=8;
	odevv.features=0;
	odev=&odevv;

	skb_init();

	struct sk_buff* skb_p=fill_packet_ipv4(odev, pkt_dev);
	if(!skb_p){
		printf("NULL skb");
		return -1;
	}
	memcpy(skb,skb_p,sk_size);
	init_skb2(skb,sk);
	printf("tcp_hdr=%s",tcp_hdr(skb_p));
	printf("tcp_hdr flags=%s",tcp_flag_word(tcp_hdr(skb_p)));
//	printf("%d,%d,%d",sizeof(struct sock),sizeof(struct sk_buff),sizeof(struct tcphdr));
	//printk("size of sock",sizeof(struct sock));
//tcp_v4_rcv(skb);

	th=tcp_hdr(skb);
	//printf("%s",(tcp_flag_word(th)));
	tcp_rcv_established(sk,skb,th,skb->len);
	//skb_header_pointer(&skb,offset,len,buff);
	return 1;
}



