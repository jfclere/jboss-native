#!/bin/sh
# Copyright(c) 2011 Red Hat Middleware, LLC,
# and individual contributors as indicated by the @authors tag.
# See the copyright.txt in the distribution for a
# full listing of individual contributors.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library in the file COPYING.LIB;
# if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
#
# @author Jean-Frederic Clere
#
echo ""
echo "Running `basename $0` $LastChangedDate: 2011-05-06 16:35:58 +0200 (Fri, 06 May 2011) $"
echo ""
echo "Started : `date`"
echo "Params  : $@"
echo ""

# Globals
build_top=`pwd`
export build_top

# Get the binaries
./files.sh || exit 1

mvn install || exit 1

echo ""
echo "SUCCESS : `basename $0` $LastChangedDate: 2011-05-06 16:35:58 +0200 (Fri, 06 May 2011) $"
echo ""
