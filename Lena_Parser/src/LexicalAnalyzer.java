import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;

enum Token {
    LPAREN, RPAREN, OR, XOR, AND, NOT, VAR, END
}

public class LexicalAnalyzer {
    private InputStream is;
    private int curChar;
    private char var;
    private int curPos;
    private Token curToken;

    public LexicalAnalyzer(InputStream is) throws ParseException {
        this.is = is;
        curPos = 0;
        nextChar();
        nextToken();
    }

    private boolean isBlank(int c) {
        return c == ' ' || c == '\r' || c == '\n' || c == '\t';
    }

    private void nextChar() throws ParseException {
        curPos++;
        try {
            curChar = is.read();
        } catch (IOException e) {
            throw new ParseException(e.getMessage(), curPos);
        }
    }

    public void nextToken() throws ParseException {
        while (isBlank(curChar)) {
            nextChar();
        }
        switch (curChar) {
            case '(':
                nextChar();
                curToken = Token.LPAREN;
                break;
            case ')':
                nextChar();
                curToken = Token.RPAREN;
                break;
            case '|':
                nextChar();
                curToken = Token.OR;
                break;
            case '^':
                nextChar();
                curToken = Token.XOR;
                break;
            case '&':
                nextChar();
                curToken = Token.AND;
                break;
            case '!':
                nextChar();
                curToken = Token.NOT;
                break;
            case -1:
                curToken = Token.END;
                break;
            default:
                var = (char) curChar;
                nextChar();
                curToken = Token.VAR;
                if (curChar != ')' && !isBlank(curChar) && curChar != -1 && curChar != '^' && curChar != '|'&& curChar != '&') {
                    throw new ParseException("Illegal variable" + (char) curChar, curPos);
                }
        }
    }

    public Token curToken() {
        return curToken;
    }

    public int curPos() {
        return curPos;
    }

    public char getVar() {
        return var;
    }
}