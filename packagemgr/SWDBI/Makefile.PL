use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'SWDBI',
    VERSION_FROM      => 'lib/SWDBI.pm', # finds 0.01
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    (5.022001 >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/SWDBI.pm', # retrieve abstract from module
       AUTHOR         => 'Kent Mein <XXXYOUREMAILHERE>') : ()),
);
