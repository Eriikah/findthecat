package semantique;

import java.util.ArrayList;

import ast.Ast;
import ast.TypeId;
import ast.FunctionCall;
import ast.Idf;
import tds.Tds;

public class DeclarationControl extends Control {

    public DeclarationControl(Ast ast, Tds tds, ArrayList<Tds> tdsList) {
        super(ast, tds, tdsList);
    }

    @Override
    public int control() {
        int error = 0;
        if (ast instanceof FunctionCall) {
            FunctionCall FunctionCall = (FunctionCall) ast;
            if (getTds(FunctionCall.Idf.name) == null) {
                System.err.println("DeclarationError" +
                        String.format("'%s' isn't defined", FunctionCall.Idf.name));
                error++;
            }

        } else if (ast instanceof TypeId) {
            TypeId typeId = (TypeId) ast;
            int returnerr = 0;
            for (Tds tds : tdsList) {
                if (tds.getSymbol(typeId.value) == null && !typeId.value.equals("int")
                        && !typeId.value.equals("string")) {
                    returnerr = 1;
                } else {
                    returnerr = 0;
                    break;
                }
            }
            if (returnerr != 0) {
                System.err.println("TypeID DeclarationError : " +
                        String.format("'%s' isn't defined", typeId.value));
                error++;

            }
        } else if (ast instanceof Idf) {
            Idf id = (Idf) ast;
            int returnerr = 0;
            for (Tds tds : tdsList) {
                if (tds.getSymbol(id.name) == null) {
                    returnerr = 1;
                } else {
                    returnerr = 0;
                    break;
                }
            }
            if (returnerr != 0) {
                System.err.println("DeclarationError : " +
                        String.format("'%s' isn't defined", id.name));
                error++;

            }
        }
        return error;
    }

}