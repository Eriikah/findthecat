package ast;

public class Not implements Ast {

    public <T> T accept(AstVisitor<T> visitor) {
        return visitor.visit(this);
    }

    public int value;

    public Not(int value) {
        this.value = value;
    }

}
