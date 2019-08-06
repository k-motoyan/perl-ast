use utf8;
use strict;
use warnings;
use lib "local/lib";
use DDP;
use Term::ANSIColor qw(:constants);
use Compiler::Lexer;
use Compiler::Parser;
use Compiler::Parser::AST::Renderer;

my $target_dir = $ARGV[0];
for my $filename ( glob $target_dir . "/*.pm" ) {
    open(my $fh, "<", $filename) or die("Cannot open $filename: $!");
    my $script = do { local $/; <$fh> };
    my $lexer  = Compiler::Lexer->new($filename);
    my $tokens = $lexer->tokenize($script);
    my $parser = Compiler::Parser->new();
    my $ast = $parser->parse($tokens);

    print_name( $ast->root, 0 );
}

sub print_name {
    my ( $node, $depth ) = @_;

    foreach ( @{$node->branches} ) {
        my $next_node = $node->{$_};

        if ( ref $next_node eq "ARRAY" ) {
            print_name( $_, $depth ) foreach ( @{$next_node} );
        }
        else {
            my $name = $next_node->token->name;
            my $data = $next_node->data;
            print "  " foreach ( 1..$depth );
            print BOLD, CYAN, "$name: $data", RESET;
            print "\n";
            print_name( $next_node, $depth+1 );
        }

    }
}
