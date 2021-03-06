local arch = 'x86_64'
cflags{
	'-D _XOPEN_SOURCE=700',
	'-nostdinc',
	'-I $srcdir/arch/'..arch,
	'-I $srcdir/arch/generic',
	'-I $outdir',
	'-I $srcdir/src/include',
	'-I $srcdir/src/internal',
	'-I $outdir/include',
}

local basefiles = load('base.lua')
local archfiles = load(arch..'.lua')

local bits = {}
for _, hdr in ipairs(archfiles.bits) do
	archfiles.bits[hdr] = true
end
for _, hdr in ipairs(basefiles.bits) do
	if not archfiles.bits[hdr] then
		table.insert(bits, hdr)
	end
end

pkg.hdrs = {
	copy('$outdir/include', '$srcdir/include', basefiles.hdrs),
	copy('$outdir/include/bits', '$srcdir/arch/'..arch..'/bits', archfiles.bits),
	copy('$outdir/include/bits', '$srcdir/arch/generic/bits', bits),
	'$outdir/include/bits/alltypes.h',
	'$outdir/include/bits/syscall.h',
}
pkg.deps = {
	'$dir/headers',
	'$outdir/version.h',
}

build('sed', '$outdir/include/bits/alltypes.h', {
	'$srcdir/arch/'..arch..'/bits/alltypes.h.in',
	'$srcdir/include/alltypes.h.in',
	'|', '$srcdir/tools/mkalltypes.sed',
}, {expr='-f $srcdir/tools/mkalltypes.sed'})

build('sed', '$outdir/include/bits/syscall.h', {'$srcdir/arch/'..arch..'/bits/syscall.h.in'}, {
	expr='-n -e ps,__NR_,SYS_,p',
})

build('awk', '$outdir/version.h', '$dir/ver', {expr=[['{printf "#define VERSION \"%s\"\n", $$1}']]})

local srcmap, srcs = {}, {}
for src in iterstrings{basefiles.srcs, archfiles.srcs} do
	srcmap[src:match('(.*)%.'):gsub('/'..arch..'/', '/', 1)] = src
end
for _, src in pairs(srcmap) do
	table.insert(srcs, src)
end

lib('libc.a', srcs)
build('cc', '$outdir/crt1.o', '$srcdir/crt/crt1.c')
build('cc', '$outdir/crti.o', '$srcdir/crt/crti.c')
build('cc', '$outdir/crtn.o', '$srcdir/crt/crtn.c')
build('cc', '$outdir/rcrt1.o', '$srcdir/crt/rcrt1.c', {cflags='$cflags -fPIC'})

phony('startfiles', {
	'$outdir/libc.a',
	'$outdir/crt1.o',
	'$outdir/crti.o',
	'$outdir/crtn.o',
	'$outdir/rcrt1.o',
})

fetch 'git'
