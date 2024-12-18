-- Este módulo define los tipos de términos y valores en la consigna junto a algunos
-- tipos auxiliares. Los tipos definidos acá ya cuentan con todas las extensiones 
-- planteadas en el TP, por lo que no se debería modificar.
module Common where

  -- Comandos interactivos o de archivos
  data Stmt i = Def String i           --  Declarar un nuevo identificador x, let x = t
              | Eval i                 --  Evaluar el término
    deriving (Show)
  
  instance Functor Stmt where
    fmap f (Def s i) = Def s (f i)
    fmap f (Eval i)  = Eval (f i)

  -- Tipos de los nombres
  data Name =  Global  String
    deriving (Show, Eq)

  -- Entornos
  type NameEnv v t = [(Name, (v, t))]

  -- Tipo de los tipos
  data Type = EmptyT          -- Tipo vacío.
            | FunT Type Type  -- Tipo función.
            -- Sección 8
            | NatT
            | ListT
            deriving (Show, Eq)
  
  -- Términos con nombres
  data LamTerm  =  LVar String
                |  LAbs String Type LamTerm  -- Es a la Church y lazy (cuerpo sin eval).
                |  LApp LamTerm LamTerm
                -- Sección 8
                |  LLet String LamTerm LamTerm
                -- naturales 
                |  LZero
                |  LSuc LamTerm
                |  LRec LamTerm LamTerm LamTerm
                -- listas
                |  LNil
                |  LCons LamTerm LamTerm
                |  LRecL LamTerm LamTerm LamTerm
                deriving (Show, Eq)


  -- Términos localmente sin nombres
  data Term  = Bound Int            -- Representa una variable ligada. 
             | Free Name            -- Representa una variable libre. Name = String. 
             | Term :@: Term        -- Aplicación.
             | Lam Type Term        -- Abstracción.
             -- Sección 8
             | Let Term Term        -- Como perdí la x ya que lo representamos sin nombres, es como si en t2 tuviera \x. t2 y por eso le sumo 1 en sub.
             -- naturales
             | Zero
             | Suc Term
             | Rec Term Term Term
             -- listas
             | Nil
             | Cons Term Term
             | RecL Term Term Term
          deriving (Show, Eq)

  -- Valores
  data Value = VLam Type Term 
             -- Sección 8
             | VNum NumVal
             | VList ListVal
             
           deriving (Show, Eq)

  -- Valores Numericos
  data NumVal = NZero | NSuc NumVal deriving (Show, Eq)

  -- Listas de números
  data ListVal = VNil | VCons NumVal ListVal deriving (Show, Eq)
   
  -- Contextos del tipado
  type Context = [Type]
