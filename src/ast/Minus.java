package ast;

public class Minus implements Ast {

    public <T> T accept(AstVisitor<T> visitor) {
        return visitor.visit(this);
    }

    public Ast left;
    public Ast right;
    private int ligne;

    public Minus(Ast left, Ast right, int ligne) {
        this.left = left;
        this.right = right;
        this.ligne = ligne;
    }

    public int getLigne() {
        return this.ligne;
    }
}
