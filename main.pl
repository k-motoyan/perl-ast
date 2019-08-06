use utf8;
use strict;
use warnings;
use lib "local/lib";
use DDP;
use Term::ANSIColor qw(:constants);
use Compiler::Lexer;
use Compiler::Parser;
use Compiler::Parser::AST::Renderer;

use constant {
    CLASS             => "Class",
    USED_NAME         => "UsedName",
    LOCAL_VAR         => "LocalVar",
    GLOBAL_VAR        => "GlobalVar",
    LOCAL_ARRAY_VAR   => "LocalArrayVar",
    GLOBAL_ARRAY_VAR  => "GlobalArrayVar",
    LOCAL_ARRAY_VAR   => "LocalHashVar",
    GLOBAL_ARRAY_VAR  => "GlobalHashVar",
    FUNCTION          => "Function",
    BUILT_IN_FUNCTION => "BuiltinFunc",
    RETURN            => "Return",
    INT               => "Int",
    STRING            => "String",
    ASSIGN            => "Assign",
    POINTER           => "Pointer",
    LEFT_PARENTHESIS  => "LeftParenthesis",
    LEFT_BRACE        => "LeftBrace",
    KEY               => "Key",
    METHOD            => "Method",
    REG_LIST          => "RegList",
    REG_EXP           => "RegExp",
};

# local $struct = {
#     Name            => "class name",
#     Uses            => ["using modules"],
#     LocalVars       => ["local variables"],
#     Functions       => [$function_structs],
# }

# local $function_struct = {
#     Type  => "function type: 0 => pure, 1 => instance, 2 => static",
#     Exprs => ["function expires"],
# }

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

    my $name = $node->token->name;
    my $data = $node->data;

    print "  " foreach ( 1..$depth );
    print BOLD, CYAN, "$name: $data", RESET;
    print "\n";

    foreach ( @{$node->branches} ) {
        my $next_node = $node->{$_};

        if ( ref $next_node eq "ARRAY" ) {
            print_name( $_, $depth ) foreach ( @{$next_node} );
        }
        else {
            print_name( $next_node, $depth+1 );
        }

    }
}
