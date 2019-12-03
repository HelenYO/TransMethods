import java.io.InputStream;
import java.text.ParseException;

public class Parser {
    private LexicalAnalyzer lexer;

    private Tree S() throws ParseException {
        switch (lexer.curToken()) {
            case NOT:
            case VAR:
            case LPAREN:
                return new Tree("S", A(), SPrime());
            case END:
                return new Tree("S", new Tree("ε"));
            default:
                throw new ParseException("Wrong token: " + lexer.curToken() + ", Index: ", lexer.curPos());
        }
    }

    private Tree SPrime() throws ParseException {
        switch (lexer.curToken()) {
            case OR:
                lexer.nextToken();
                return new Tree("S'", new Tree("|"), A(), SPrime());
            case END:
            case RPAREN:
                return new Tree("S'", new Tree("ε"));
            default:
                throw new ParseException("Wrong token: " + lexer.curToken() + ", Index: ", lexer.curPos());
        }
    }


    private Tree A() throws ParseException {
        switch (lexer.curToken()) {
            case NOT:
            case VAR:
            case LPAREN:
                return new Tree("A", B(), APrime());
            default:
                throw new ParseException("Wrong token: " + lexer.curToken() +
                        ", Index: ", lexer.curPos());
        }
    }

    private Tree APrime() throws ParseException {
        switch (lexer.curToken()) {
            case XOR:
                lexer.nextToken();
                return new Tree("A'", new Tree("^"), B(), APrime());
            case END:
            case RPAREN:
            case OR:
                return new Tree("A'", new Tree("ε"));
            default:
                throw new ParseException("Wrong token: " + lexer.curToken() +
                        ", Index: ", lexer.curPos());
        }
    }


    private Tree B() throws ParseException {
        switch (lexer.curToken()) {
            case NOT:
            case VAR:
            case LPAREN:
                return new Tree("B", C(), BPrime());
            default:
                throw new ParseException("Wrong token: " + lexer.curToken() + ", Index: ", lexer.curPos());
        }
    }

    private Tree BPrime() throws ParseException {
        switch (lexer.curToken()) {
            case AND:
                lexer.nextToken();
                return new Tree("B'", new Tree("&"), C(), BPrime());
            case END:
            case RPAREN:
            case OR:
            case XOR:
                return new Tree("B'", new Tree("ε"));
            default:
                throw new ParseException("Wrong token: " + lexer.curToken() + ", Index: ", lexer.curPos());
        }
    }

    private Tree C() throws ParseException {
        switch (lexer.curToken()) {
            case NOT:
                lexer.nextToken();
                return new Tree("C", new Tree("!"), C());
            case VAR:
            case LPAREN:
                return new Tree("C", D());
            default:
                throw new ParseException("Wrong token: " + lexer.curToken() + ", Index: ", lexer.curPos());
        }
    }

    private Tree D() throws ParseException {
        switch (lexer.curToken()) {
            case VAR:
                char var = lexer.getVar();
                lexer.nextToken();
                return new Tree("D", new Tree(Character.toString(var)));
            case LPAREN:
                lexer.nextToken();
                Tree nextS = S();

                if (lexer.curToken() != Token.RPAREN) {
                    throw new ParseException("Wrong token: " + lexer.curToken() + ", Index: ", lexer.curPos());
                }

                lexer.nextToken();
                Tree leftP = new Tree("(");
                Tree rightP = new Tree(")");
                return new Tree("D", leftP, nextS, rightP);
            default:
                throw new ParseException("Wrong token: " + lexer.curToken() + ", Index: ", lexer.curPos());
        }
    }


    public Tree parse(InputStream stream) throws ParseException {
        lexer = new LexicalAnalyzer(stream);
        Tree ret = S();
        if (lexer.curToken() == Token.END) {
            return ret;
        }
        throw new ParseException("Expected end " + "Index: ", lexer.curPos());
    }
}