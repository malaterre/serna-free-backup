// 
// Copyright(c) 2009 Syntext, Inc. All Rights Reserved.
// Contact: info@syntext.com, http://www.syntext.com
// 
// This file is part of Syntext Serna XML Editor.
// 
// COMMERCIAL USAGE
// Licensees holding valid Syntext Serna commercial licenses may use this file
// in accordance with the Syntext Serna Commercial License Agreement provided
// with the software, or, alternatively, in accorance with the terms contained
// in a written agreement between you and Syntext, Inc.
// 
// GNU GENERAL PUBLIC LICENSE USAGE
// Alternatively, this file may be used under the terms of the GNU General 
// Public License versions 2.0 or 3.0 as published by the Free Software 
// Foundation and appearing in the file LICENSE.GPL included in the packaging 
// of this file. In addition, as a special exception, Syntext, Inc. gives you
// certain additional rights, which are described in the Syntext, Inc. GPL 
// Exception for Syntext Serna Free Edition, included in the file 
// GPL_EXCEPTION.txt in this package.
// 
// You should have received a copy of appropriate licenses along with this 
// package. If not, see <http://www.syntext.com/legal/>. If you are unsure
// which license is appropriate for your use, please contact the sales 
// department at sales@syntext.com.
// 
// This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
// WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
// 
// Copyright (c) 2003 Syntext Inc.
//
// This is a copyrighted commercial software.
// Please see COPYRIGHT file for details.

/** \file
 *  Interface to a generic spell checker
 */

#ifndef SPELL_CHECKER_H_
#define SPELL_CHECKER_H_

#include "common/String.h"
#include "common/RangeString.h"
#include "common/RefCntPtr.h"
#include "common/RefCounted.h"
#include "common/OwnerPtr.h"
#include "common/Message.h"
#include "common/MessageUtils.h"
#include <list>
#include <map>
#include <set>
#include <exception>

extern const char SPELL_CFG_VAR[];
extern const char SPELL_PWSDIR_VAR[];
extern const char SPELL_DICT_VAR[];
extern const char SPELL_USE_VAR[];
extern const char SPELL_DICT[];

class SpellChecker : public Common::RefCounted<> {
public:
    typedef std::list<Common::String> Strings;
    typedef std::set<Common::String> WordSet;

    virtual const Common::String& getDict() const = 0;
    virtual bool    check(const Common::RangeString& word) const = 0;
    virtual bool    suggest(const Common::RangeString& word,
                            Strings& si) const = 0;
    virtual bool    addToPersonal(const Common::RangeString& word);
    static  bool    getDictList(Strings&);
    virtual void    resetPwl(const WordSet&) {}
    
    const WordSet&  getPwl() const { return *pws_; }
    bool            loadPwl(WordSet* to = 0);
    bool            savePwl();
    void            setPwl(WordSet*);

    static SpellChecker* make(const Common::String& lang);

    SpellChecker();
    virtual ~SpellChecker() {}

private:
    SpellChecker(const SpellChecker&);
    SpellChecker& operator=(const SpellChecker&);

    Common::OwnerPtr<WordSet> pws_;
};

class SpellCheckerSet {
public:
    SpellCheckerSet();
    ~SpellCheckerSet();

    SpellChecker&   getChecker(const Common::String& lang);
    SpellChecker&   defaultChecker() const { return *defaultChecker_; }
    void            setDict(const Common::RangeString&);

    void            addToIgnored(const Common::RangeString&);
    bool            isIgnored(const Common::RangeString&) const;
    void            clearIgnoreDict() { ignoredWords_.clear(); }

private:
    typedef std::map<Common::String, 
        Common::RefCntPtr<SpellChecker> > SpellCheckerMap;
    typedef std::set<Common::String> IgnoreDict;

    SpellCheckerSet(const SpellCheckerSet&);
    SpellCheckerSet& operator=(const SpellCheckerSet&);

    SpellCheckerMap spellCheckers_;
    IgnoreDict      ignoredWords_;
    Common::RefCntPtr<SpellChecker> defaultChecker_;
    Common::RefCntPtr<SpellChecker> currentChecker_;
    SpellCheckerMap::const_iterator lastChecker_;
};

#endif

