/******************************************************************************
    Copyright (C) 2013 by Hugh Bailey <obs.jim@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
******************************************************************************/

#include "platform.h"

#include <unistd.h>

#import <AppKit/AppKit.h>

const char* GetDefaultEventsSavePath()
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *url = [fm URLForDirectory:NSMoviesDirectory
	              inDomain:NSUserDomainMask
	              appropriateForURL:nil
	              create:true
	              error:nil];

	if (!url)
		return getenv("HOME");

    return url.path.fileSystemRepresentation;
}
