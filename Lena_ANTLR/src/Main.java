import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.TokenStream;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class Main {
    public static void main(String[] args) throws IOException {
        Path pathToInputFile = Paths.get("test2.txt");
        ANTLRInputStream reader = new ANTLRInputStream(Files.newInputStream(pathToInputFile));
        perfectLLexer lexer = new perfectLLexer(reader);
        TokenStream tokens = new CommonTokenStream(lexer);
        perfectLParser parser = new perfectLParser(tokens);
        parser.program();
        //
//        if($typeIdentifier == nullptr) {
//            System.out.println("void ");
//        } else {
//            System.out.println($typeIdentifier.text + " ");
//        }
//        System.out.println($name_func.text + "(");
//        for (int i = 0; i < $formalParameterList.size();i++) {
//
//        }
    }
}