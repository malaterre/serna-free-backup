// Copyright (c) 1997 James Clark
// See the file COPYING for copying permission.

#if defined(__GNUG__) && defined(GNUG_PRAGMA_INTERFACE)
#pragma implementation
#endif

#include "splib.h"
#include "CodingSystemKit.h"
#include "TranslateCodingSystem.h"
#ifdef SP_MULTI_BYTE
#include "UTF8CodingSystem.h"
#include "Fixed2CodingSystem.h"
#include "UnicodeCodingSystem.h"
#include "XMLCodingSystem.h"
#include "EUCJPCodingSystem.h"
#include "SJISCodingSystem.h"
#include "Big5CodingSystem.h"
#ifdef WIN32
#include "Win32CodingSystem.h"
#endif
#endif /* SP_MULTI_BYTE */
#include "IdentityCodingSystem.h"
#include "Owner.h"

#include <ctype.h>

#ifdef SP_NAMESPACE
namespace SP_NAMESPACE {
#endif

#ifdef SP_MULTI_BYTE
const Char unicodeReplaceChar = 0xfffd;
#endif

class CodingSystemKitImpl : public CodingSystemKit {
public:
  CodingSystemKitImpl(const TranslateCodingSystem::Desc *);
  CodingSystemKit *copy() const;
  Char replacementChar() const;
  const CodingSystem *
    identityCodingSystem() const;
  const InputCodingSystem *
    identityInputCodingSystem() const;
  const InputCodingSystem *
    makeInputCodingSystem(const StringC &,
			  const CharsetInfo &,
			  Boolean isBctf,
			  const char *&) const;
  const CodingSystem *
    makeCodingSystem(const char *, Boolean isBctf) const;
  enum CodingSystemId {
    identity,
    fixed2,
    utf8,
    unicode,
    eucjp,
    euccn,
    euckr,
    sjisBctf,
    eucBctf,
    sjis,
    big5,
    big5Bctf,
    ansi,
    oem,
    maybeUnicode,
    xml,
    iso8859_1,
    iso8859_2,
    iso8859_3,
    iso8859_4,
    iso8859_5,
    iso8859_6,
    iso8859_7,
    iso8859_8,
    iso8859_9,
    iso8859_15,
    koi8_r,
    cp1250,
    cp1251,
    cp1252,
    cp1253,
    cp1254,
    cp1255,
    cp1256,
    cp1257,
    cp1258
  };
  struct Entry {
    const char *name;
    CodingSystemId id;
  };
  static Boolean match(const StringC &s,
		       const CharsetInfo &charset,
		       const char *key);
  static Boolean match(const char *s,
		       const char *key);
private:
  const CodingSystem *
    makeCodingSystem(CodingSystemId) const;
  const Entry *firstEntry(Boolean isBctf) const;
#ifdef SP_MULTI_BYTE
  UTF8CodingSystem utf8CodingSystem_;
  Fixed2CodingSystem fixed2CodingSystem_;
  UnicodeCodingSystem unicodeCodingSystem_;
  XMLCodingSystem xmlCodingSystem_;
  EUCJPCodingSystem eucBctf_;
  SJISCodingSystem sjisBctf_;
  Big5CodingSystem big5Bctf_;
  TranslateCodingSystem eucjpCodingSystem_;
  TranslateCodingSystem euccnCodingSystem_;
  TranslateCodingSystem euckrCodingSystem_;
  TranslateCodingSystem sjisCodingSystem_;
  TranslateCodingSystem big5CodingSystem_;
  TranslateCodingSystem iso8859_1CodingSystem_;
  TranslateCodingSystem iso8859_2CodingSystem_;
  TranslateCodingSystem iso8859_3CodingSystem_;
  TranslateCodingSystem iso8859_4CodingSystem_;
  TranslateCodingSystem iso8859_5CodingSystem_;
  TranslateCodingSystem iso8859_6CodingSystem_;
  TranslateCodingSystem iso8859_7CodingSystem_;
  TranslateCodingSystem iso8859_8CodingSystem_;
  TranslateCodingSystem iso8859_9CodingSystem_;
  TranslateCodingSystem iso8859_15CodingSystem_;
  TranslateCodingSystem koi8_rCodingSystem_;
  TranslateCodingSystem cp1250CodingSystem_;
  TranslateCodingSystem cp1251CodingSystem_;
  TranslateCodingSystem cp1252CodingSystem_;
  TranslateCodingSystem cp1253CodingSystem_;
  TranslateCodingSystem cp1254CodingSystem_;
  TranslateCodingSystem cp1255CodingSystem_;
  TranslateCodingSystem cp1256CodingSystem_;
  TranslateCodingSystem cp1257CodingSystem_;
  TranslateCodingSystem cp1258CodingSystem_;
#ifdef WIN32
  Win32CodingSystem ansiCodingSystem_;
  Win32CodingSystem oemCodingSystem_;
  UnicodeCodingSystem maybeUnicodeCodingSystem_;
#endif
#endif /* SP_MULTI_BYTE */
  IdentityCodingSystem identityCodingSystem_;
  const TranslateCodingSystem::Desc *systemCharsetDesc_;
  static const Entry bctfTable_[];
  enum { nEncodingsRequireUnicode = 8 };
  static const Entry encodingTable_[];
};


static const TranslateCodingSystem::Desc iso10646Desc[] = {
  { CharsetRegistry::ISO10646_UCS2, 0x0 },
  { CharsetRegistry::UNREGISTERED, 0x0 },
};

#ifdef SP_MULTI_BYTE

static const TranslateCodingSystem::Desc jisDesc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_JIS_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::JIS0201, 0x80 },
  { CharsetRegistry::JIS0208, 0x8080 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc jis2Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_JIS_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::JIS0201, 0x80 },
  { CharsetRegistry::JIS0208, 0x8080 },
  { CharsetRegistry::JIS0212, 0x8000 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc gbDesc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::GB2312, 0x8080 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc big5Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::BIG5, 0x0 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc kscDesc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::KSC5601, 0x8080 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_1Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_1, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_2Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_2, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_3Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_3, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_4Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_4, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_5Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_5, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_6Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_6, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_7Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_7, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_8Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_8, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_9Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_9, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc iso8859_15Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::ISO6429, 0x80 },
  { CharsetRegistry::ISO8859_15, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc koi8_rDesc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  // FIXME: only GR part of KOI8-R is handled (i.e. 160..255)
  //        since koi8-r does not follow ISO control/graphic model
  { CharsetRegistry::KOI8_R, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc cp1250Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::CP1250, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc cp1251Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::CP1251, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc cp1252Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::CP1252, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc cp1253Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::CP1253, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc cp1254Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::CP1254, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc cp1255Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::CP1255, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc cp1256Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::CP1256, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc cp1257Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::CP1257, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

static const TranslateCodingSystem::Desc cp1258Desc[] = {
  { CharsetRegistry::ISO646_C0, 0x0 },
  { CharsetRegistry::ISO646_ASCII_G0, 0x0 },
  { CharsetRegistry::CP1258, 0x80 },
  { CharsetRegistry::UNREGISTERED, 0x0 }
};

#endif /* SP_MULTI_BYTE */

const CodingSystemKitImpl::Entry CodingSystemKitImpl::bctfTable_[] = {
  { "IDENTITY", identity },
#ifdef SP_MULTI_BYTE
  { "FIXED-2", fixed2 },
  { "UTF-8", utf8 },
  { "EUC", eucBctf },
  { "SJIS", sjisBctf },
  { "BIG5", big5Bctf },
#endif /* SP_MULTI_BYTE */
  { 0, identity },
};

const CodingSystemKitImpl::Entry CodingSystemKitImpl::encodingTable_[] = {
#ifdef SP_MULTI_BYTE
  { "UTF-8", utf8 },
  { "UCS-2", fixed2 },
  { "ISO-10646-UCS-2", fixed2 },
  { "UNICODE", unicode },
  { "WINDOWS", ansi },
  { "MS-DOS", oem },
  { "WUNICODE", maybeUnicode },
  { "XML", xml },
  // nEncodingsRequireUnicode = 8
  { "IS8859-1", iso8859_1 },
  { "ISO-8859-1", iso8859_1 },
  { "IS8859-2", iso8859_2 },
  { "ISO-8859-2", iso8859_2 },
  { "IS8859-3", iso8859_3 },
  { "ISO-8859-3", iso8859_3 },
  { "IS8859-4", iso8859_4 },
  { "ISO-8859-4", iso8859_4 },
  { "IS8859-5", iso8859_5 },
  { "ISO-8859-5", iso8859_5 },
  { "IS8859-6", iso8859_6 },
  { "ISO-8859-6", iso8859_6 },
  { "IS8859-7", iso8859_7 },
  { "ISO-8859-7", iso8859_7 },
  { "IS8859-8", iso8859_8 },
  { "ISO-8859-8", iso8859_8 },
  { "IS8859-9", iso8859_9 },
  { "ISO-8859-9", iso8859_9 },
  { "IS8859-15", iso8859_9 },
  { "ISO-8859-15", iso8859_15 },
  { "KOI8-R", koi8_r }, // RFC 1489
  { "KOI8", koi8_r },
  { "CP1250", cp1250 },
  { "CP 1250", cp1250 },
  { "windows-1250", cp1250 },
  { "CP1251", cp1251 },
  { "CP 1251", cp1251 },
  { "windows-1251", cp1251 },
  { "CP1252", cp1252 },
  { "CP 1252", cp1252 },
  { "windows-1252", cp1252 },
  { "CP1253", cp1253 },
  { "CP 1253", cp1253 },
  { "windows-1253", cp1253 },
  { "CP1254", cp1254 },
  { "CP 1254", cp1254 },
  { "windows-1254", cp1254 },
  { "CP1255", cp1255 },
  { "CP 1255", cp1255 },
  { "windows-1255", cp1255 },
  { "CP1256", cp1256 },
  { "CP 1256", cp1256 },
  { "windows-1256", cp1256 },
  { "CP1257", cp1257 },
  { "CP 1257", cp1257 },
  { "windows-1257", cp1257 },
  { "CP1258", cp1258 },
  { "CP 1258", cp1258 },
  { "windows-1258", cp1258 },
  { "EUC-JP", eucjp },
  { "EUC-CN", euccn },
  { "GB2312", euccn },
  { "CN-GB", euccn },  // RFC 1922
  { "EUC-KR", euckr },
  { "SJIS", sjis },
  { "SHIFT_JIS", sjis },
  { "BIG5", big5 },
  { "CN-BIG5", big5 }, // RFC 1922
#endif /* SP_MULTI_BYTE */
  { 0, identity },
};

CodingSystemKitImpl::CodingSystemKitImpl(const TranslateCodingSystem::Desc *systemCharsetDesc)
: systemCharsetDesc_(systemCharsetDesc)
#ifdef SP_MULTI_BYTE
  ,
#ifdef WIN32
  ansiCodingSystem_(Win32CodingSystem::codePageAnsi),
  oemCodingSystem_(Win32CodingSystem::codePageOEM),
  maybeUnicodeCodingSystem_(&ansiCodingSystem_),
#endif
  xmlCodingSystem_(this),
  iso8859_1CodingSystem_(&identityCodingSystem_, iso8859_1Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  iso8859_2CodingSystem_(&identityCodingSystem_, iso8859_2Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  iso8859_3CodingSystem_(&identityCodingSystem_, iso8859_3Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  iso8859_4CodingSystem_(&identityCodingSystem_, iso8859_4Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  iso8859_5CodingSystem_(&identityCodingSystem_, iso8859_5Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  iso8859_6CodingSystem_(&identityCodingSystem_, iso8859_6Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  iso8859_7CodingSystem_(&identityCodingSystem_, iso8859_7Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  iso8859_8CodingSystem_(&identityCodingSystem_, iso8859_8Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  iso8859_9CodingSystem_(&identityCodingSystem_, iso8859_9Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  iso8859_15CodingSystem_(&identityCodingSystem_, iso8859_15Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  koi8_rCodingSystem_(&identityCodingSystem_, koi8_rDesc, &systemCharset_, 0x100, unicodeReplaceChar),
  cp1250CodingSystem_(&identityCodingSystem_, cp1250Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  cp1251CodingSystem_(&identityCodingSystem_, cp1251Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  cp1252CodingSystem_(&identityCodingSystem_, cp1252Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  cp1253CodingSystem_(&identityCodingSystem_, cp1253Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  cp1254CodingSystem_(&identityCodingSystem_, cp1254Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  cp1255CodingSystem_(&identityCodingSystem_, cp1255Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  cp1256CodingSystem_(&identityCodingSystem_, cp1256Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  cp1257CodingSystem_(&identityCodingSystem_, cp1257Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  cp1258CodingSystem_(&identityCodingSystem_, cp1258Desc, &systemCharset_, 0x100, unicodeReplaceChar),
  eucjpCodingSystem_(&eucBctf_, jis2Desc, &systemCharset_, 0x8000, unicodeReplaceChar),
  euccnCodingSystem_(&eucBctf_, gbDesc, &systemCharset_, 0x8000, unicodeReplaceChar),
  euckrCodingSystem_(&eucBctf_, kscDesc, &systemCharset_, 0x8000, unicodeReplaceChar),
  sjisCodingSystem_(&sjisBctf_, jisDesc, &systemCharset_, 0x8000, unicodeReplaceChar),
  big5CodingSystem_(&big5Bctf_, big5Desc, &systemCharset_, 0x0080, unicodeReplaceChar)
#endif /* SP_MULTI_BYTE */
{
  UnivCharsetDesc desc;
  for (const TranslateCodingSystem::Desc *p = systemCharsetDesc_;
       p->number != CharsetRegistry::UNREGISTERED;
       p++) {
    Owner<CharsetRegistry::Iter> iter(CharsetRegistry::makeIter(p->number));
    if (iter) {
      WideChar min;
      WideChar max;
      UnivChar univ;
      while (iter->next(min, max, univ)) {
	min += p->add;
	max += p->add;
	if (min <= charMax) {
	  if (max > charMax)
	    max = charMax;
	  desc.addRange(min, max, univ);
	}
      }
    }
  }
  systemCharset_.set(desc);
}

CodingSystemKit *CodingSystemKitImpl::copy() const
{
  return new CodingSystemKitImpl(systemCharsetDesc_);
}

const CodingSystemKitImpl::Entry *CodingSystemKitImpl::firstEntry(Boolean isBctf) const
{
  if (isBctf)
    return bctfTable_;
#ifdef SP_MULTI_BYTE
  else if (systemCharsetDesc_ != iso10646Desc)
    return encodingTable_ + nEncodingsRequireUnicode;
#endif
  else
    return encodingTable_;
}

const InputCodingSystem *
CodingSystemKitImpl::makeInputCodingSystem(const StringC &s,
					   const CharsetInfo &charset,
					   Boolean isBctf,
					   const char *&key) const
{
  for (const Entry *p = firstEntry(isBctf); p->name; p++)
    if (match(s, charset, p->name)) {
      key = p->name;
      return makeCodingSystem(p->id);
    }
  return 0;
}

Boolean
CodingSystemKitImpl::match(const StringC &s,
			   const CharsetInfo &charset,
			   const char *key)
{
  for (size_t i = 0; i < s.size(); i++) {
    if (key[i] == '\0')
      return 0;
    if (charset.execToDesc(toupper(key[i])) != s[i]
        && charset.execToDesc(tolower(key[i])) != s[i])
      return 0;
  }
  return key[s.size()] == '\0';
}

const CodingSystem *
CodingSystemKitImpl::makeCodingSystem(const char *s,
				      Boolean isBctf)
  const
{
 for (const Entry *p = firstEntry(isBctf); p->name; p++)
   if (match(s, p->name))
      return makeCodingSystem(p->id);
  return 0;
}

Boolean
CodingSystemKitImpl::match(const char *s,
			   const char *key)
{
  for (; toupper(*key) == *s || tolower(*key) == *s; s++, key++) {
    if (*s == '\0')
      return 1;
  }
  return 0;
}

const CodingSystem *
CodingSystemKitImpl::makeCodingSystem(CodingSystemId id) const
{
  switch (id) {
  case identity:
    return &identityCodingSystem_;
#ifdef SP_MULTI_BYTE
  case fixed2:
    return &fixed2CodingSystem_;
  case utf8:
    return &utf8CodingSystem_;
  case unicode:
    return &unicodeCodingSystem_;
  case eucBctf:
    return &eucBctf_;
  case sjisBctf:
    return &sjisBctf_;
  case big5Bctf:
    return &big5Bctf_;
  case eucjp:
    return &eucjpCodingSystem_;
  case euccn:
    return &euccnCodingSystem_;
  case euckr:
    return &euckrCodingSystem_;
  case sjis:
    return &sjisCodingSystem_;
  case big5:
    return &big5CodingSystem_;
  case iso8859_1:
    if (systemCharsetDesc_ == iso10646Desc)
      return &identityCodingSystem_;
    else
      return &iso8859_1CodingSystem_;
  case iso8859_2:
    return &iso8859_2CodingSystem_;
  case iso8859_3:
    return &iso8859_3CodingSystem_;
  case iso8859_4:
    return &iso8859_4CodingSystem_;
  case iso8859_5:
    return &iso8859_5CodingSystem_;
  case iso8859_6:
    return &iso8859_6CodingSystem_;
  case iso8859_7:
    return &iso8859_7CodingSystem_;
  case iso8859_8:
    return &iso8859_8CodingSystem_;
  case iso8859_9:
    return &iso8859_9CodingSystem_;
  case iso8859_15:
    return &iso8859_15CodingSystem_;
  case koi8_r:
    return &koi8_rCodingSystem_;
  case cp1250:
    return &cp1250CodingSystem_;
  case cp1251:
    return &cp1251CodingSystem_;
  case cp1252:
    return &cp1252CodingSystem_;
  case cp1253:
    return &cp1253CodingSystem_;
  case cp1254:
    return &cp1254CodingSystem_;
  case cp1255:
    return &cp1255CodingSystem_;
  case cp1256:
    return &cp1256CodingSystem_;
  case cp1257:
    return &cp1257CodingSystem_;
  case cp1258:
    return &cp1258CodingSystem_;
  case xml:
    return &xmlCodingSystem_;
#ifdef WIN32
  case ansi:
    return &ansiCodingSystem_;
  case oem:
    return &oemCodingSystem_;
  case maybeUnicode:
    return &maybeUnicodeCodingSystem_;
#endif /* WIN32 */
#endif /* SP_MULTI_BYTE */
  default:
    break;
  }
  return 0;
}

const InputCodingSystem *
CodingSystemKitImpl::identityInputCodingSystem() const
{
  return &identityCodingSystem_;
}

const CodingSystem *
CodingSystemKitImpl::identityCodingSystem() const
{
  return &identityCodingSystem_;
}

Char CodingSystemKitImpl::replacementChar() const
{
  // FIXME should vary with systemCharset
#ifdef SP_MULTI_BYTE
  return unicodeReplaceChar;
#else
  return 0;
#endif
}

CodingSystemKit *
CodingSystemKit::make(const char *systemCharsetName)
{
#ifdef SP_MULTI_BYTE
  if (systemCharsetName && CodingSystemKitImpl::match(systemCharsetName, "JIS"))
    return new CodingSystemKitImpl(jis2Desc);
#endif
  return new CodingSystemKitImpl(iso10646Desc);
}

InputCodingSystemKit::~InputCodingSystemKit()
{
}

#ifdef SP_NAMESPACE
}
#endif
