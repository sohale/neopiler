#include "clang/Frontend/CompilerInstance.h"
#include "clang/Parse/ParseAST.h"
#include "clang/Sema/Sema.h"

void processAST(clang::ASTContext &Ctx) {
    for (auto *D : Ctx.getTranslationUnitDecl()->decls()) {
        if (auto *FD = llvm::dyn_cast<clang::FunctionDecl>(D)) {
            llvm::outs() << "Function: " << FD->getNameAsString() << "\n";
        }
    }
}

// Possible AST nodes:  Decl, Stmt, and Expr.
