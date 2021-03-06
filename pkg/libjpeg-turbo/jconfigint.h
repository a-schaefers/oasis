#define BUILD  "20190905"
#undef inline
#define INLINE  __inline__ __attribute__((always_inline))
#define PACKAGE_NAME  "libjpeg-turbo"
#define VERSION  "2.0.3"
#define SIZEOF_SIZE_T  8
#ifdef HAVE___BUILTIN_CTZL
#define HAVE_BUILTIN_CTZL
#endif
/* #undef HAVE_INTRIN_H */
#if defined(_MSC_VER) && defined(HAVE_INTRIN_H)
#if (SIZEOF_SIZE_T == 8)
#define HAVE_BITSCANFORWARD64
#elif (SIZEOF_SIZE_T == 4)
#define HAVE_BITSCANFORWARD
#endif
#endif
