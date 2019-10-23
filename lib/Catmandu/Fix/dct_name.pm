package Catmandu::Fix::dct_name;
use strict;
use Moo;

sub fix {
    my ($self, $data) = @_;

    return $data unless exists $data->{_r} && exists $data->{_r}->{dct_name};

    my $names = ref($data->{_r}->{dct_name}) eq 'ARRAY' ?
                    $data->{_r}->{dct_name} :
                    [ $data->{_r}->{dct_name} ];

    for my $name (@$names) {
        my $relator = $name->{relator};
        my $type    = $name->{type};

        delete $name->{relator};
        delete $name->{type};

        if ($relator) {
            push @{$data->{_r}->{"marcrel_$relator"}} , $name;
        }
        elsif ($type) {
            push @{$data->{_r}->{$type}} , $name;
        }
        else {
            die "no relator or type found for " . $name->{_id};
        }
    }

    delete $data->{_r}->{dct_name};

    return $data;
}

1;

__END__

=head1 NAME

dct_name - parse dct_name fields into the correct dct_creator|dct_contributir|marcrel_*** properties

=head1 SYNOPSIS

  # dct_name:
  #   _id: http://viaf.org/viaf/71525784
  #   foaf_name: ...
  #   type: dc_contributor
  dct_name()
  # dct_contributor:
  #   _id: http://viaf.org/viaf/71525784
  #   foaf_name: ...

  # dct_name:
  #   _id: http://viaf.org/viaf/71525784
  #   foaf_name: ...
  #   type: dc_contributor
  #   relator: etd
  dct_name()
  # marcrel_etd:
  #   _id: http://viaf.org/viaf/71525784
  #   foaf_name: ...
  #   type: dc_contributor
  #   relator: etd

=cut
