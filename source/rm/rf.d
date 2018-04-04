module rm.rf;

import std.file;

void rmdirRecurseForce(in char[] pathname)
{
	//No references to pathname will be kept after rmdirRecurse,
	//so the cast is safe
	rmdirRecurseForce(DirEntry(cast(string) pathname));
}

void rmdirRecurseForce(DirEntry de)
{
	if (!de.isDir)
		throw new FileException(de.name, "Not a directory");

	if (de.isSymlink)
	{
		version (Windows)
			rmdir(de.name);
		else
			remove(de.name);
	}
	else
	{
		// all children, recursively depth-first
		foreach (DirEntry e; dirEntries(de.name, SpanMode.depth, false))
		{
			version (Windows)
			{
				import core.sys.windows.windows;

				if ((e.attributes & FILE_ATTRIBUTE_READONLY) != 0)
					setAttributes(e, e.attributes & ~FILE_ATTRIBUTE_READONLY);
			}
			attrIsDir(e.linkAttributes) ? rmdir(e.name) : remove(e.name);
		}

		// the dir itself
		rmdir(de.name);
	}
}
