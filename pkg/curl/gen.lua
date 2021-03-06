cflags{
	'-std=c99', '-Wall', '-Wpedantic',
	'-D _DEFAULT_SOURCE',
	'-D HAVE_CONFIG_H',
	'-D BUILDING_LIBCURL',
	'-D CURL_STATICLIB',
	'-I $outdir',
	'-I $outdir/include/curl',
	'-I $outdir/include',
	'-I $srcdir/lib',
	'-I $srcdir/src',
	'-I $builddir/pkg/bearssl/include',
	'-I $builddir/pkg/zlib/include',
}

build('cat', '$outdir/curl_config.h', {
	'$dir/curl_config.h',
	'$builddir/probe/SIZEOF_LONG',
	'$builddir/probe/SIZEOF_SIZE_T',
	'$builddir/probe/SIZEOF_TIME_T',
})

pkg.hdrs = copy('$outdir/include/curl', '$srcdir/include/curl', {
	'curl.h',
	'curlver.h',
	'easy.h',
	'mprintf.h',
	'stdcheaders.h',
	'multi.h',
	'typecheck-gcc.h',
	'system.h',
	'urlapi.h',
})
pkg.deps = {
	'$outdir/curl_config.h',
	'$dir/headers',
	'pkg/bearssl/headers',
	'pkg/zlib/headers',
}

-- src/lib/Makefile.inc:/^CSOURCES
lib('libcurl.a', [[
	lib/(
		file.c timeval.c base64.c hostip.c progress.c formdata.c
		cookie.c http.c sendf.c ftp.c url.c dict.c if2ip.c speedcheck.c
		ldap.c version.c getenv.c escape.c mprintf.c telnet.c netrc.c
		getinfo.c transfer.c strcase.c easy.c security.c curl_fnmatch.c
		fileinfo.c ftplistparser.c wildcard.c krb5.c memdebug.c http_chunks.c
		strtok.c connect.c llist.c hash.c multi.c content_encoding.c share.c
		http_digest.c md4.c md5.c http_negotiate.c inet_pton.c strtoofft.c
		strerror.c amigaos.c hostasyn.c hostip4.c hostip6.c hostsyn.c
		inet_ntop.c parsedate.c select.c tftp.c splay.c strdup.c socks.c
		curl_addrinfo.c socks_gssapi.c socks_sspi.c
		curl_sspi.c slist.c nonblock.c curl_memrchr.c imap.c pop3.c smtp.c
		pingpong.c rtsp.c curl_threads.c warnless.c hmac.c curl_rtmp.c
		openldap.c curl_gethostname.c gopher.c idn_win32.c
		http_proxy.c non-ascii.c asyn-ares.c asyn-thread.c curl_gssapi.c
		http_ntlm.c curl_ntlm_wb.c curl_ntlm_core.c curl_sasl.c rand.c
		curl_multibyte.c hostcheck.c conncache.c dotdot.c
		x509asn1.c http2.c smb.c curl_endian.c curl_des.c system_win32.c
		mime.c sha256.c setopt.c curl_path.c curl_ctype.c curl_range.c psl.c
		doh.c urlapi.c curl_get_line.c altsvc.c socketpair.c
		vauth/(
			vauth.c cleartext.c cram.c
			digest.c digest_sspi.c krb5_gssapi.c
			krb5_sspi.c ntlm.c ntlm_sspi.c oauth2.c
			spnego_gssapi.c spnego_sspi.c
		)
		vtls/(
			openssl.c gtls.c vtls.c nss.c
			polarssl.c polarssl_threadlock.c
			wolfssl.c schannel.c schannel_verify.c
			sectransp.c gskit.c mbedtls.c mesalink.c
			bearssl.c
		)
		vquic/(ngtcp2.c quiche.c)
		vssh/(libssh2.c libssh.c)
	)
	$builddir/pkg/bearssl/libbearssl.a
	$builddir/pkg/zlib/libz.a
]])

build('cc', '$outdir/tool_hugehelp.c.o', {
	'$dir/tool_hugehelp.c', '||', '$dir/deps', '$srcdir/src/tool_hugehelp.h',
})

-- src/src/Makefile.inc:/^CURL_CFILES
exe('curl', [[
	src/(
		slist_wc.c
		tool_binmode.c
		tool_bname.c
		tool_cb_dbg.c
		tool_cb_hdr.c
		tool_cb_prg.c
		tool_cb_rea.c
		tool_cb_see.c
		tool_cb_wrt.c
		tool_cfgable.c
		tool_convert.c
		tool_dirhie.c
		tool_doswin.c
		tool_easysrc.c
		tool_filetime.c
		tool_formparse.c
		tool_getparam.c
		tool_getpass.c
		tool_help.c
		tool_helpers.c
		tool_homedir.c
		tool_libinfo.c
		tool_main.c
		tool_metalink.c
		tool_msgs.c
		tool_operate.c
		tool_operhlp.c
		tool_panykey.c
		tool_paramhlp.c
		tool_parsecfg.c
		tool_progress.c
		tool_strdup.c
		tool_setopt.c
		tool_sleep.c
		tool_urlglob.c
		tool_util.c
		tool_vms.c
		tool_writeout.c
		tool_xattr.c
	)
	tool_hugehelp.c.o
	libcurl.a.d
]])

file('bin/curl', '755', '$outdir/curl')
man{'docs/curl.1'}

fetch 'curl'
