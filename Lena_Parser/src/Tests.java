import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Scanner;

public class Tests {
    private static final String RED = "\u001B[31m";
    private static final String WHITE = "\u001B[0m";

    private static void dfs(Tree v, StringBuilder sb) {
        if (v.children == null) {
            if (!v.node.equals("ε")) {
                if (v.node.equals("(")){
                    sb.append("(");
                } else if (v.node.equals(")")) {
                    sb.deleteCharAt(sb.length() - 1);
                    sb.append(")").append(" ");
                } else {
                    sb.append(v.node).append(" ");
                }
            }
        } else {
            for (Tree ch : v.children) {
                dfs(ch, sb);
            }
        }
    }

    static void testLexer(InputStream is) {
        try {
            LexicalAnalyzer lex = new LexicalAnalyzer(is);
            lex.nextToken();
            while (lex.curToken() != Token.END) {
                System.out.print(lex.curToken() + " ");
                lex.nextToken();
            }
        } catch (ParseException e) {
            System.out.println(e.getMessage());
        }

    }

    public static void main(String[] args) {
//        String[] strings = {"", "a & b & c", " (a & b) | ! (c ^ (a | ! b))",
//                "a & b", " a | c ^ p & v", "((a & a)", "(b & e))",
//                " a & ", " & b", "&", "| v", "v |", "(a & b) | ! (c ^ (a | ! b))", "a ^ b | c" , "a | b ^ c"};
//        String[] strings = {"(a & b) | ! (c ^ (a | ! b))", "a ^ b" , "a | b ^ c"};
        //String[] strings = {"(a & b)", "! (a & b)", "(a ^ b ^ c)"};
        String[] strings = {"! ! a"};
        int passed = 0;

        for (String string : strings) {
            ArrayList<String> tokens = new ArrayList<String>();
            InputStream inputStream = new ByteArrayInputStream(string.getBytes(Charset.forName("UTF-8")));
            try {
                Parser parser = new Parser();
                Tree root = parser.parse(inputStream);
                Scanner tokenize = new Scanner(string);
                while (tokenize.hasNext()) {
                    tokens.add(tokenize.next());
                }
                StringBuilder builderAns = new StringBuilder();
                for (String str : tokens) {
                    builderAns.append(str).append(" ");
                }
                System.out.println(builderAns.toString());
                StringBuilder builderDfs = new StringBuilder();
                dfs(root, builderDfs);

                if (builderAns.toString().equals(builderDfs.toString())) {
                    System.out.println(builderDfs.toString());
                    System.out.println("OK");
                    passed++;
                } else {
                    int ind = 0;
                    while(builderAns.charAt(ind) == builderDfs.charAt(ind)) {ind++;}
                    StringBuilder tmp = new StringBuilder();
                    tmp.append(" ".repeat(Math.max(0, ind)));
                    tmp.append(RED + '^');
                    System.out.println(tmp);
                    System.out.println(WHITE + builderDfs.subSequence(0, ind) + RED + builderDfs.charAt(ind) +
                            WHITE + builderDfs.subSequence(ind + 1, builderDfs.length()));
                    System.out.println(RED + "test not passed");
                }

                System.out.println();

                root.drawTree(0);
                } catch (ParseException e) {
                System.out.println(e.getMessage() + e.getErrorOffset());
            }
        }
        if(passed == strings.length) {
            System.out.println("\n _________ ALL PASSED _________ ");
        }
    }
    //◉◡◉
}