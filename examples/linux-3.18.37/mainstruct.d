mainstruct.bc: mainstruct.c include/linux/kconfig.h \
  include/generated/autoconf.h include/linux/mm.h include/linux/errno.h \
  include/uapi/linux/errno.h arch/x86/include/uapi/asm/errno.h \
  include/uapi/asm-generic/errno.h include/uapi/asm-generic/errno-base.h \
  include/linux/mmdebug.h include/linux/stringify.h include/linux/gfp.h \
  include/linux/mmzone.h include/linux/spinlock.h \
  include/linux/typecheck.h include/linux/preempt.h \
  include/linux/linkage.h include/linux/compiler.h \
  include/linux/compiler-gcc.h include/linux/compiler-clang.h \
  include/uapi/linux/types.h arch/x86/include/uapi/asm/types.h \
  include/uapi/asm-generic/types.h include/asm-generic/int-ll64.h \
  include/uapi/asm-generic/int-ll64.h \
  arch/x86/include/uapi/asm/bitsperlong.h \
  include/asm-generic/bitsperlong.h \
  include/uapi/asm-generic/bitsperlong.h \
  include/uapi/linux/posix_types.h include/linux/stddef.h \
  include/uapi/linux/stddef.h arch/x86/include/asm/posix_types.h \
  arch/x86/include/uapi/asm/posix_types_64.h \
  include/uapi/asm-generic/posix_types.h include/linux/export.h \
  arch/x86/include/asm/linkage.h include/linux/list.h \
  include/linux/types.h include/linux/poison.h \
  include/uapi/linux/const.h include/linux/kernel.h \
  /usr/lib/llvm-3.5/bin/../lib/clang/3.5.0/include/stdarg.h \
  include/linux/bitops.h arch/x86/include/asm/bitops.h \
  arch/x86/include/asm/alternative.h arch/x86/include/asm/asm.h \
  arch/x86/um/asm/ptrace.h arch/um/include/asm/ptrace-generic.h \
  arch/x86/include/uapi/asm/ptrace-abi.h \
  arch/x86/um/shared/sysdep/ptrace.h include/generated/user_constants.h \
  arch/x86/um/shared/sysdep/faultinfo.h \
  arch/x86/um/shared/sysdep/faultinfo_64.h \
  arch/x86/um/shared/sysdep/ptrace_64.h \
  arch/x86/include/asm/cpufeature.h arch/x86/um/asm/required-features.h \
  arch/x86/include/asm/disabled-features.h arch/x86/include/asm/rmwcc.h \
  arch/um/include/generated/asm/barrier.h include/asm-generic/barrier.h \
  include/asm-generic/bitops/find.h include/asm-generic/bitops/sched.h \
  arch/x86/um/asm/arch_hweight.h \
  include/asm-generic/bitops/arch_hweight.h \
  include/asm-generic/bitops/const_hweight.h \
  include/asm-generic/bitops/le.h arch/x86/include/uapi/asm/byteorder.h \
  include/linux/byteorder/little_endian.h \
  include/uapi/linux/byteorder/little_endian.h include/linux/swab.h \
  include/uapi/linux/swab.h arch/x86/include/uapi/asm/swab.h \
  include/linux/byteorder/generic.h \
  include/asm-generic/bitops/ext2-atomic-setbit.h include/linux/log2.h \
  include/linux/printk.h include/linux/init.h \
  include/linux/kern_levels.h include/linux/cache.h \
  include/uapi/linux/kernel.h include/uapi/linux/sysinfo.h \
  arch/um/include/asm/cache.h include/linux/dynamic_debug.h \
  include/linux/string.h include/uapi/linux/string.h \
  arch/x86/include/asm/string.h arch/x86/include/asm/string_64.h \
  arch/um/include/generated/asm/preempt.h include/asm-generic/preempt.h \
  include/linux/thread_info.h include/linux/bug.h \
  arch/um/include/generated/asm/bug.h include/asm-generic/bug.h \
  arch/um/include/asm/thread_info.h arch/um/include/asm/page.h \
  arch/x86/um/asm/vm-flags.h arch/um/include/shared/mem.h \
  include/asm-generic/memory_model.h include/asm-generic/getorder.h \
  arch/um/include/asm/uaccess.h arch/x86/um/asm/processor.h \
  arch/x86/um/asm/processor_64.h arch/x86/include/asm/user.h \
  arch/x86/include/asm/user_64.h arch/um/include/asm/processor-generic.h \
  arch/um/include/shared/registers.h \
  arch/x86/um/shared/sysdep/archsetjmp.h \
  arch/x86/um/shared/sysdep/archsetjmp_64.h include/linux/prefetch.h \
  arch/x86/um/asm/elf.h arch/um/include/shared/skas/skas.h \
  include/linux/irqflags.h arch/um/include/asm/irqflags.h \
  include/linux/bottom_half.h include/linux/preempt_mask.h \
  include/linux/spinlock_types.h include/linux/spinlock_types_up.h \
  include/linux/lockdep.h include/linux/rwlock_types.h \
  include/linux/spinlock_up.h include/linux/rwlock.h \
  include/linux/spinlock_api_up.h include/linux/atomic.h \
  arch/x86/include/asm/atomic.h arch/x86/include/asm/cmpxchg.h \
  arch/x86/include/asm/cmpxchg_64.h arch/x86/include/asm/atomic64_64.h \
  include/asm-generic/atomic-long.h include/linux/wait.h \
  arch/um/include/generated/asm/current.h include/asm-generic/current.h \
  include/uapi/linux/wait.h include/linux/threads.h include/linux/numa.h \
  include/linux/seqlock.h include/linux/nodemask.h \
  include/linux/bitmap.h include/linux/pageblock-flags.h \
  include/linux/page-flags-layout.h include/generated/bounds.h \
  include/linux/memory_hotplug.h include/linux/notifier.h \
  include/linux/mutex.h include/linux/osq_lock.h include/linux/rwsem.h \
  arch/x86/include/asm/rwsem.h include/linux/srcu.h \
  include/linux/rcupdate.h include/linux/cpumask.h \
  include/linux/completion.h include/linux/debugobjects.h \
  include/linux/rcutiny.h include/linux/workqueue.h \
  include/linux/timer.h include/linux/ktime.h include/linux/time.h \
  include/linux/math64.h arch/x86/include/asm/div64.h \
  include/asm-generic/div64.h include/linux/time64.h \
  include/uapi/linux/time.h include/linux/jiffies.h \
  include/linux/timex.h include/uapi/linux/timex.h \
  include/uapi/linux/param.h arch/um/include/generated/asm/param.h \
  include/asm-generic/param.h include/uapi/asm-generic/param.h \
  arch/um/include/asm/timex.h include/linux/timekeeping.h \
  include/linux/topology.h include/linux/smp.h include/linux/llist.h \
  include/linux/percpu.h include/linux/pfn.h \
  arch/um/include/generated/asm/percpu.h include/asm-generic/percpu.h \
  include/linux/percpu-defs.h arch/um/include/generated/asm/topology.h \
  include/asm-generic/topology.h include/linux/rbtree.h \
  include/linux/debug_locks.h include/linux/mm_types.h \
  include/linux/auxvec.h include/uapi/linux/auxvec.h \
  arch/x86/include/uapi/asm/auxvec.h include/linux/page-debug-flags.h \
  include/linux/uprobes.h arch/um/include/asm/mmu.h \
  arch/um/include/shared/skas/mm_id.h arch/x86/um/asm/mm_context.h \
  arch/x86/include/uapi/asm/ldt.h include/linux/range.h \
  include/linux/bit_spinlock.h include/linux/shrinker.h \
  include/linux/resource.h include/uapi/linux/resource.h \
  arch/x86/include/uapi/asm/resource.h include/asm-generic/resource.h \
  include/uapi/asm-generic/resource.h arch/um/include/asm/pgtable.h \
  arch/um/include/asm/fixmap.h arch/um/include/asm/kmap_types.h \
  arch/x86/um/asm/archparam.h include/asm-generic/fixmap.h \
  arch/um/include/asm/pgtable-3level.h \
  include/asm-generic/pgtable-nopud.h include/asm-generic/pgtable.h \
  include/linux/page-flags.h include/linux/huge_mm.h \
  include/linux/vmstat.h include/linux/vm_event_item.h include/net/tcp.h \
  include/linux/tcp.h include/linux/skbuff.h include/linux/kmemcheck.h \
  include/linux/net.h include/linux/random.h include/uapi/linux/random.h \
  include/uapi/linux/ioctl.h arch/x86/include/uapi/asm/ioctl.h \
  include/asm-generic/ioctl.h include/uapi/asm-generic/ioctl.h \
  include/linux/irqnr.h include/uapi/linux/irqnr.h include/linux/fcntl.h \
  include/uapi/linux/fcntl.h arch/x86/include/uapi/asm/fcntl.h \
  include/uapi/asm-generic/fcntl.h include/linux/jump_label.h \
  include/uapi/linux/net.h include/linux/socket.h \
  arch/x86/include/uapi/asm/socket.h include/uapi/asm-generic/socket.h \
  arch/x86/include/uapi/asm/sockios.h include/uapi/asm-generic/sockios.h \
  include/uapi/linux/sockios.h include/linux/uio.h \
  include/uapi/linux/uio.h include/uapi/linux/socket.h \
  include/linux/textsearch.h include/linux/err.h include/linux/slab.h \
  include/linux/kmemleak.h include/net/checksum.h \
  arch/x86/um/asm/checksum.h include/linux/in6.h \
  include/uapi/linux/in6.h include/uapi/linux/libc-compat.h \
  arch/x86/um/asm/checksum_64.h include/linux/hrtimer.h \
  include/linux/timerqueue.h include/linux/dma-mapping.h \
  include/linux/device.h include/linux/ioport.h include/linux/kobject.h \
  include/linux/sysfs.h include/linux/kernfs.h include/linux/idr.h \
  include/linux/kobject_ns.h include/linux/stat.h \
  arch/x86/include/uapi/asm/stat.h include/uapi/linux/stat.h \
  include/linux/uidgid.h include/linux/highuid.h include/linux/kref.h \
  include/linux/klist.h include/linux/pinctrl/devinfo.h \
  include/linux/pm.h include/linux/ratelimit.h \
  arch/um/include/generated/asm/device.h include/asm-generic/device.h \
  include/linux/pm_wakeup.h include/linux/dma-attrs.h \
  include/linux/dma-direction.h include/linux/scatterlist.h \
  arch/um/include/generated/asm/scatterlist.h \
  include/asm-generic/scatterlist.h arch/um/include/generated/asm/io.h \
  include/asm-generic/io.h include/asm-generic/pci_iomap.h \
  include/linux/vmalloc.h include/asm-generic/dma-mapping-broken.h \
  include/linux/netdev_features.h include/linux/sched.h \
  include/uapi/linux/sched.h include/linux/sched/prio.h \
  include/linux/capability.h include/uapi/linux/capability.h \
  include/linux/plist.h include/linux/cputime.h \
  arch/um/include/generated/asm/cputime.h include/asm-generic/cputime.h \
  include/asm-generic/cputime_jiffies.h include/linux/sem.h \
  include/uapi/linux/sem.h include/linux/ipc.h include/uapi/linux/ipc.h \
  arch/x86/include/uapi/asm/ipcbuf.h include/uapi/asm-generic/ipcbuf.h \
  arch/x86/include/uapi/asm/sembuf.h include/linux/shm.h \
  include/uapi/linux/shm.h arch/x86/include/uapi/asm/shmbuf.h \
  include/uapi/asm-generic/shmbuf.h arch/x86/include/asm/shmparam.h \
  include/linux/signal.h include/uapi/linux/signal.h \
  arch/x86/include/asm/signal.h arch/x86/include/uapi/asm/signal.h \
  include/uapi/asm-generic/signal-defs.h \
  arch/x86/include/asm/sigcontext.h \
  arch/x86/include/uapi/asm/sigcontext.h \
  arch/x86/include/uapi/asm/siginfo.h include/asm-generic/siginfo.h \
  include/uapi/asm-generic/siginfo.h include/linux/pid.h \
  include/linux/proportions.h include/linux/percpu_counter.h \
  include/linux/seccomp.h include/uapi/linux/seccomp.h \
  include/linux/rculist.h include/linux/rtmutex.h \
  include/linux/task_io_accounting.h include/linux/latencytop.h \
  include/linux/cred.h include/linux/key.h include/linux/sysctl.h \
  include/uapi/linux/sysctl.h include/linux/assoc_array.h \
  include/linux/selinux.h include/uapi/linux/magic.h \
  include/net/flow_keys.h include/net/sock.h include/linux/hardirq.h \
  include/linux/ftrace_irq.h include/linux/vtime.h \
  include/linux/context_tracking_state.h include/linux/static_key.h \
  arch/um/include/generated/asm/hardirq.h include/asm-generic/hardirq.h \
  include/linux/irq_cpustat.h include/linux/irq.h \
  include/linux/irqreturn.h arch/um/include/asm/irq.h \
  arch/um/include/generated/asm/irq_regs.h \
  include/asm-generic/irq_regs.h include/linux/irqdesc.h \
  arch/um/include/generated/asm/hw_irq.h include/asm-generic/hw_irq.h \
  include/linux/list_nulls.h include/linux/netdevice.h \
  include/linux/pm_qos.h include/linux/miscdevice.h \
  include/uapi/linux/major.h include/linux/delay.h \
  arch/um/include/generated/asm/delay.h include/asm-generic/delay.h \
  include/linux/dmaengine.h include/linux/dynamic_queue_limits.h \
  include/linux/ethtool.h include/linux/compat.h \
  include/uapi/linux/ethtool.h include/linux/if_ether.h \
  include/uapi/linux/if_ether.h include/net/net_namespace.h \
  include/net/flow.h include/net/netns/core.h include/net/netns/mib.h \
  include/net/snmp.h include/uapi/linux/snmp.h \
  include/linux/u64_stats_sync.h include/net/netns/unix.h \
  include/net/netns/packet.h include/net/netns/ipv4.h \
  include/net/inet_frag.h include/net/netns/ipv6.h include/net/dst_ops.h \
  include/net/netns/ieee802154_6lowpan.h include/net/netns/sctp.h \
  include/net/netns/dccp.h include/net/netns/netfilter.h \
  include/linux/proc_fs.h include/linux/fs.h include/linux/kdev_t.h \
  include/uapi/linux/kdev_t.h include/linux/dcache.h \
  include/linux/rculist_bl.h include/linux/list_bl.h \
  include/linux/lockref.h include/linux/path.h include/linux/list_lru.h \
  include/linux/radix-tree.h include/linux/semaphore.h \
  include/uapi/linux/fiemap.h include/linux/migrate_mode.h \
  include/linux/percpu-rwsem.h include/linux/blk_types.h \
  include/uapi/linux/fs.h include/uapi/linux/limits.h \
  include/linux/quota.h include/uapi/linux/dqblk_xfs.h \
  include/linux/dqblk_v1.h include/linux/dqblk_v2.h \
  include/linux/dqblk_qtree.h include/linux/projid.h \
  include/uapi/linux/quota.h include/linux/nfs_fs_i.h \
  include/linux/netfilter.h include/uapi/linux/if.h \
  include/uapi/linux/hdlc/ioctl.h include/linux/in.h \
  include/uapi/linux/in.h include/uapi/linux/netfilter.h \
  include/net/netns/x_tables.h include/net/netns/nftables.h \
  include/net/netns/xfrm.h include/uapi/linux/xfrm.h \
  include/net/flowcache.h include/linux/interrupt.h \
  include/linux/seq_file_net.h include/linux/seq_file.h \
  include/linux/nsproxy.h include/net/dsa.h include/linux/of.h \
  include/linux/mod_devicetable.h include/linux/uuid.h \
  include/uapi/linux/uuid.h include/linux/property.h include/linux/phy.h \
  include/linux/mii.h include/uapi/linux/mii.h include/linux/phy_fixed.h \
  include/net/netprio_cgroup.h include/linux/cgroup.h \
  include/uapi/linux/cgroupstats.h include/uapi/linux/taskstats.h \
  include/linux/percpu-refcount.h include/uapi/linux/neighbour.h \
  include/linux/netlink.h include/net/scm.h include/linux/security.h \
  include/uapi/linux/netlink.h include/uapi/linux/netdevice.h \
  include/uapi/linux/if_packet.h include/linux/if_link.h \
  include/uapi/linux/if_link.h include/linux/uaccess.h \
  include/linux/memcontrol.h include/linux/res_counter.h \
  include/linux/aio.h include/uapi/linux/aio_abi.h \
  include/linux/filter.h arch/x86/include/asm/cacheflush.h \
  include/asm-generic/cacheflush.h arch/x86/include/asm/special_insns.h \
  include/uapi/linux/filter.h include/uapi/linux/bpf_common.h \
  include/uapi/linux/bpf.h include/linux/rculist_nulls.h \
  include/linux/poll.h include/uapi/linux/poll.h \
  arch/x86/include/uapi/asm/poll.h include/uapi/asm-generic/poll.h \
  include/net/dst.h include/linux/rtnetlink.h \
  include/uapi/linux/rtnetlink.h include/uapi/linux/if_addr.h \
  include/net/neighbour.h include/net/rtnetlink.h include/net/netlink.h \
  include/net/tcp_states.h include/uapi/linux/net_tstamp.h \
  include/net/inet_connection_sock.h include/net/inet_sock.h \
  include/linux/jhash.h include/linux/unaligned/packed_struct.h \
  include/net/request_sock.h include/net/netns/hash.h \
  include/net/inet_timewait_sock.h include/net/timewait_sock.h \
  include/uapi/linux/tcp.h include/linux/crypto.h \
  include/linux/cryptohash.h include/net/inet_hashtables.h \
  include/linux/ip.h include/uapi/linux/ip.h include/linux/ipv6.h \
  include/uapi/linux/ipv6.h include/linux/icmpv6.h \
  include/uapi/linux/icmpv6.h include/linux/udp.h \
  include/uapi/linux/udp.h include/net/route.h include/net/inetpeer.h \
  include/net/ipv6.h include/net/if_inet6.h include/net/ndisc.h \
  include/linux/if_arp.h include/uapi/linux/if_arp.h \
  include/linux/hash.h arch/um/include/generated/asm/hash.h \
  include/asm-generic/hash.h include/uapi/linux/in_route.h \
  include/uapi/linux/route.h include/net/ip.h include/net/inet_ecn.h \
  include/net/dsfield.h include/net/inet_common.h \
  /playpen/ziqiao/2project/klee/include/klee/klee.h \
  /usr/lib/llvm-3.5/bin/../lib/clang/3.5.0/include/stdint.h \
  /usr/lib/llvm-3.5/bin/../lib/clang/3.5.0/include/stddef.h \
  include/linux/sys.h include/linux/module.h include/linux/kmod.h \
  include/linux/elf.h include/uapi/linux/elf.h \
  include/uapi/linux/elf-em.h include/linux/moduleparam.h \
  arch/x86/um/asm/module.h include/uapi/linux/unistd.h \
  arch/x86/include/asm/unistd.h arch/x86/include/uapi/asm/unistd.h \
  arch/x86/include/generated/uapi/asm/unistd_64.h \
  arch/x86/include/generated/asm/unistd_64_x32.h include/linux/ptrace.h \
  include/linux/pid_namespace.h include/uapi/linux/ptrace.h \
  include/linux/freezer.h include/linux/inet.h \
  include/linux/inetdevice.h include/linux/if_vlan.h \
  include/linux/etherdevice.h arch/x86/include/asm/unaligned.h \
  include/linux/unaligned/access_ok.h include/linux/unaligned/generic.h \
  include/uapi/linux/if_vlan.h include/linux/kthread.h include/net/udp.h \
  include/net/ip6_checksum.h include/net/addrconf.h \
  include/net/netns/generic.h include/linux/io.h \
  arch/um/include/asm/dma.h
