/* Generated By:JJTree: Do not edit this line. ASTUnaryExpression.java */

package net.sourceforge.pmd.ast;

public class ASTUnaryExpression extends SimpleNode {
    public ASTUnaryExpression(int id) {
        super(id);
    }

    public ASTUnaryExpression(JavaParser p, int id) {
        super(p, id);
    }

    private boolean isPositive;
    private boolean isPlaceholder = true;

    public void setNegative() {
        isPositive = false;
        isPlaceholder = false;
    }

    public void setPositive() {
        isPositive = true;
        isPlaceholder = false;
    }

    public boolean isPositive() {
        if (isPlaceholder) return false;
        return isPositive;
    }

    public boolean isPlaceholder() {
        return isPlaceholder;
    }

    public boolean isNegative() {
        if (isPlaceholder) return false;
        return !isPositive;
    }

    public void dump(String prefix) {
        if (isPlaceholder) {
            System.out.println(toString(prefix) + ":" + ("(placeholder)"));
        } else {
            System.out.println(toString(prefix) + ":" + (isPositive ? "+" : "-"));
        }
        dumpChildren(prefix);
    }

    /** Accept the visitor. **/
    public Object jjtAccept(JavaParserVisitor visitor, Object data) {
        return visitor.visit(this, data);
    }
}
