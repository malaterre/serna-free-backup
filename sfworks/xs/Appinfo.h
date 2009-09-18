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
/*! \file
 */

#ifndef APPINFO_H_
#define APPINFO_H_

#include "xs/xs_defs.h"
#include "grove/Decls.h"
#include "common/Vector.h"
#include "common/RefCntPtr.h"
#include "common/RefCounted.h"
#include "common/String.h"

#ifdef _MSC_VER
# include "grove/Nodes.h"
#endif

class GroveAstParser;

XS_NAMESPACE_BEGIN

/*! Application-specific information associated with particular
    schema construct.
 */
class XS_EXPIMP Appinfo : public COMMON_NS::RefCounted<> {
public:
    /*! Number of Appinfo elements
     */
    ulong            nAppinfo() const;
    const COMMON_NS::String&     pythonScript() const;
    const COMMON_NS::String&     documentation() const;

    /*! Pointer to certain <appinfo> element in the parsed schema
     */
    const COMMON_NS::RefCntPtr<GROVE_NAMESPACE::Element>& appinfoElement(ulong index) const;

    Appinfo();
    ~Appinfo();

    XS_OALLOC(Appinfo);

private:
    friend class ::GroveAstParser;
    void addAppinfo(COMMON_NS::RefCntPtr<GROVE_NAMESPACE::Element> elem);
    void addDocumentation(const COMMON_NS::String& doc);
    void setPythonScript(const COMMON_NS::String& script);

    COMMON_NS::Vector<COMMON_NS::RefCntPtr<GROVE_NAMESPACE::Element> > elems_;
    COMMON_NS::String                   script_;
    COMMON_NS::String                   doc_;
};

/////////////////////////////////////////////////////////////

inline ulong Appinfo::nAppinfo() const
{
    return elems_.size();
}

inline const COMMON_NS::RefCntPtr<GROVE_NAMESPACE::Element>&
  Appinfo::appinfoElement(ulong index) const
{
    return elems_[index];
}

inline const COMMON_NS::String& Appinfo::documentation() const
{
    return doc_;
}

inline void Appinfo::addDocumentation(const COMMON_NS::String& doc)
{
    doc_ += doc;
}

XS_NAMESPACE_END

#endif // APPINFO_H_
