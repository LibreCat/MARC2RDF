package Catmandu::Fix::rdf_ldf_statements;

use Catmandu::Sane;
use Moo;
use RDF::LDF;
use Catmandu::Fix::Has;

has path      => (fix_arg => 1);
has subject   => (fix_opt => 1, default => sub { undef });
has predicate => (fix_opt => 1, default => sub { undef });
has url       => (fix_opt => 1, default => sub { undef });

has client    => (is => 'lazy');

with 'Catmandu::Fix::SimpleGetValue';

sub _build_client {
    my ($self) = @_;
    my $url = $self->url // 'http://data.linkeddatafragments.org/viaf';
    RDF::LDF->new(url => $url);
}

sub emit_value {
    my ($self,$var,$fixer) = @_;
    my $subject_var   = $fixer->capture($self->subject);
    my $predicate_var = $fixer->capture($self->predicate);
    my $client_var    = $fixer->capture($self->client);
    my $it            = $fixer->generate_var;
    my $st            = $fixer->generate_var;

    my $perl = <<EOF;
if (is_value(${var})) {
    my ${it} = ${client_var}->get_statements(${subject_var},${predicate_var},${var});
    if (${it}) {
      ${var} = [];
      while (my ${st} = ${it}->()) {
          push \@{${var}} , ${st}->subject->uri;
      }
    }
}
EOF
    $perl;
}

=head1 NAME

Catmandu::Fix::rdf_ldf_statements - lookup an object into a LDF endpoint

=head1 SYNOPSIS

    # Replace a name with an array of matching VIAF records
    # name: "\"Einstein, Albert, 1879-1955\""
    rdf_ldf_statements(name,url:"http://data.linkedatafragments.org/viaf",predicate:"http://schema.org/alternateName")

    # name:
    #   - http://viaf.org/viaf/75121530

=head1 SEE ALSO

L<Catmandu::Fix>

=cut

1;
