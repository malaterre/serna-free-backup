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

#include "qdir.h"
#include "xslt/impl/utils.h"
#include "grove/Node.h"
#include "grove/NodeExt.h"
#include "common/String.h"
#include "common/Url.h"

using namespace Common;

namespace Xslt
{

String getRelativePath(const String& includeUri,
                       const String& stylesheetUri)
{
    return Url(stylesheetUri).combinePath2Path(includeUri);
}

String line_info(const GroveLib::Node* n)
{
    String str;
    if (n->grove())
        str += "URL: " + n->grove()->topSysid();
    if (n->nodeExt() && n->nodeExt()->asLineLocExt()) {
        GroveLib::LineLocExt* ext = n->nodeExt()->asLineLocExt();
        str += " (line: " + String::number(ext->line());
        str += " column: " + String::number(ext->column() + 1) + ")";
    }
    str += "\nname: " + n->nodeName();
    return str;
}

} // namespace Xslt
