import java.util.Arrays;
import java.util.List;


public class Tree {
    String node;
    List<Tree> children;

    public static final String WHITE = "\u001B[0m";
    public static final String RED = "\u001B[31m";

    public Tree(String node) {
        this.node = node;
    }

    public Tree(String node, Tree... children) {
        this.node = node;
        this.children = Arrays.asList(children);
    }

    public void drawTree(int indent) {
        String whiteSpaces = ".  ".repeat(Math.max(0, (indent)/3));
        //String whiteSpaces = " ".repeat(indent);
        String edge = "┗——";
        if (children != null) {
            for (Tree ch : children) {
                System.out.print(whiteSpaces);
                System.out.print(edge);
                if (ch.node.equals("ε")) {
                    System.out.println(RED+ ch.node + WHITE);
                } else if (ch.children == null) {
                    System.out.println(RED + ch.node + WHITE);
                } else {
                    System.out.println(ch.node + WHITE);
                }
                ch.drawTree(indent + 3);
            }
        }
    }
}