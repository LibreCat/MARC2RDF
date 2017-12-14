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

  Display the contents of the MARC file:

```(bash)
  $ catmandu convert MARC to MARCMaker < data/camel.mrc
```

  Convert the data/camel.mrc file to NTriples:

```(bash)
  $ catmandu convert MARC --fix fix/camel.fix --fix fix/marc_rdf_dct.fix to NTriples < data/camel.mrc
```

  Alternative, display not RDF but a YAML output

```(bash)
  $ catmandu convert MARC --fix fix/camel.fix --fix fix/marc_rdf_dct.fix to YAML < data/camel.mrc
```

  The file `fix/camel.fix` contains specific fixes to create a `subject` for the RDF
  records. In the Fix file, the MARC `001` field is mapped to the `_id` field, which
  will be the subject for all triples.

  The file `fix/marc_rdf_dct.fix` is a generic conversion script to map MARC to Dublin Core.

  Optionally the file `fix/viaf_lookup.fix` can be added to attempt to lookup author names
  against the VIAF database using [Linked Data Fragments](http://linkeddatafragments.org/):

```(bash)
  $ catmandu convert ALEPHSEQ --fix fix/rug01.fix --fix fix/marc_rdf_dct.fix --fix fix/viaf_lookup.fix to NTriples < data/rug01.aleph
```

  In the example above we used the fact that the 'data/rug01.aleph' file has the Ex Libris
  Aleph sequential format instead of the ISO2709 MARC format.

  Use [Catmandu](https://metacpan.org/pod/Catmandu) for more elaborate fixes and transformations

  Big open catalog data sets are available at the [Library of Congress](http://www.loc.gov/cds/products/marcDist.php).

```(bash)
  $ wget http://www.loc.gov/cds/downloads/MDSConnect/BooksAll.2014.part01.utf8.gz
  $ catmandu convert MARC --fix/loc.fix --fix fix/marc_rdf_dct.fix < BooksAll.2014.part01.utf8 > part01.nt
```

# DETAILS

To convert MARC into RDF triples, the MARC field needs to be converted by Catmandu in a special
format: [aREF](https://metacpan.org/pod/RDF::aREF)

To see how MARC looks like without any special conversions execute the command below:

```(bash)
  $ catmandu convert MARC to YAML < data/camel.mrc
```

The output will produce for every record in the MARC input a YAML document containing the `_id` of
the MARC record and in `record` the MARC data. This `record` is an array of arrays. Mapping are needed
to transform this array of arrays into the aREF format which is a hash. The Catmandu Fix language
can be used to transform data in the MARC `record` to aREF fields. E.g.

```(bash)
   $ catmandu convert MARC --fix 'marc_map(245,dct_title); remove_field(record)' to YAML <   data/camel.mrc
 ---
 _id: 'fol05731351 '
 dct_title: ActivePerl with ASP and ADO /Tobias Martinsson.
 ...
 ---
 _id: 'fol05754809 '
 dct_title: Programming the Perl DBI /Alligator Descartes and Tim Bunce.
 ...
```

Maps the MARC `245` field to a Dublin Core title. Many mappings will be used to create RDF, this can all be
done with Catmandu Fixes. To group all these fixes, they are written in a Fix script. When providing
a Fix script on the command line all Fix commands in it will be executed.

```(bash)
   $ catmandu convert MARC --fix fix/camel.fix --fix fix/marc_rdf_dct.fix to YAML < data/camel.mrc
```

The command above will execute all the fixes in `fix/camel.fix` and `fix/marc_rdf_dct.fix` on
each MARC record in the `data/camel.mrc` file.

The output of this command is the aREF format we are searching for:

```(yaml)
---
_id: http://somewhere.org/fol05731351
dct_created:
- 2000@
dct_creator:
- foaf_name: Martinsson, Tobias,@
  schema_birthDate: 1976@
  schema_deathDate: 1976@
dct_date:
- 2000@
- 2000@
dct_dateCopyrighted:
- 2000@
dct_extent:
- xxi, 289 p. :@
dct_identifier:
- 0471383147@
dct_issued:
- 2000@
- 2000@
dct_language:
- eng@
dct_publisher:
- 'New York : John Wiley & Sons,@'
dct_subject:
- QA76.73.P22 M33 2000@
- 005.13/3 21@
- Active server pages.@
- ActiveX.@
- Perl (Computer program language)@
dct_title:
- ActivePerl with ASP and ADO / Tobias Martinsson.@
dct_type:
- text@
...
```

When you delete the `to YAML` arguments from the command line then the default Catmandu
Exporter defined in `catmandu.yml` RDF/NTriples will be executed which can understand
aREF and transforms it into triples.

```(bash)
   $ catmandu convert  MARC --fix fix/camel.fix --fix fix/marc_rdf_dct.fix to NTriples < data/camel.mrc
 _id: http://somewhere.org/fol05882032
 <http://somewhere.org/fol05731351> <http://purl.org/dc/terms/language> "eng" .
 <http://somewhere.org/fol05731351> <http://purl.org/dc/terms/date> "2000" .
 <http://somewhere.org/fol05731351> <http://purl.org/dc/terms/date> "2000" .
 <http://somewhere.org/fol05731351> <http://purl.org/dc/terms/created> "2000" .
 <http://somewhere.org/fol05731351> <http://purl.org/dc/terms/issued> "2000" .
 <http://somewhere.org/fol05731351> <http://purl.org/dc/terms/issued> "2000" .
 <http://somewhere.org/fol05731351> <http://purl.org/dc/terms/creator> _:b1 .
 _:b1 <http://xmlns.com/foaf/0.1/name> "Martinsson, Tobias," .
 _:b1 <http://schema.org/birthDate> "1976" .
 _:b1 <http://schema.org/deathDate> "1976" .
 <http://somewhere.org/fol05731351> <http://purl.org/dc/terms/dateCopyrighted> "2000" .
 <http://somewhere.org/fol05731351> <http://purl.org/dc/terms/subject> "QA76.73.P22 M33 2000" .
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
