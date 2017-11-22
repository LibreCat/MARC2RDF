# NAME

LibreCat-MARC2RDF - Catmandu examples for processing MARC data into RDF triples

# INSTALL

  * Requires Perl 5.14 or better. Hit use [plenv](https://github.com/tokuhirom/plenv) to install a recent perl

```(bash)
  $ plenv local 5.14
  
  $ git clone git@github.com:LibreCat/MARC2RDF.git
  $ cd MARC2RDF
  $ cpanm
  
```

# USAGE

  Convert the data/camel.mrc file to NTriples:

```(bash)
  $ catmandu convert --fix fix/camel.fix --fix fix/marc_rdf_dct.fix < data/camel.mrc
```

  The file `fix/camel.fix` contains specific fixes to create a `subject` for the RDF
  records. In the Fix file, the MARC `001` field is mapped to the `_id` field, which
  will be the subject for all triples.

  The file `fix/marc_rdf_dct.fix` is a generic conversion script to map MARC to Dublin Core.

  Optionally the file `fix/viaf_lookup.fix` can be added to attempt to lookup author names
  against the VIAF database using [Linked Data Fragments](http://linkeddatafragments.org/):

```(bash)
  $ catmandu convert --type ALEPHSEQ --fix fix/rug01.fix --fix fix/marc_rdf_dct.fix --fix fix/viaf_lookup.fix < data/rug01.aleph
```

  In the example above we used the fact that the 'data/rug01.aleph' file has the Ex Libris
  Aleph sequential format instead of the ISO2709 MARC format.

  Use [Catmandu](https://metacpan.org/pod/Catmandu) for more elaborate fixes and transformations

  Big open catalog data sets are available at the [Library of Congress](http://www.loc.gov/cds/products/marcDist.php).

```(bash)
  $ wget http://www.loc.gov/cds/downloads/MDSConnect/BooksAll.2014.part01.utf8.gz
  $ catmandu convert --fix/loc.fix --fix fix/marc_rdf_dct.fix < BooksAll.2014.part01.utf8 > part01.nt
```

# DISCLAIMER

* I'm not an RDF/MARC expert, the example mappings provided don't use any of the recent work Bibo and other vocabularies
* This project was created as part of the [Catmandu](https://metacpan.org/pod/Catmandu) project as an example how to create RDF triples from open data
* I invite other developers to contribute to this code and provide better mappings

# AUTHOR

Patrick Hochstenbach, `<patrick.hochstenbach at ugent.be>`

# LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
