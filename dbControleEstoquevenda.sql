-- Trigger para atualizar quantidade do produto após venda
DELIMITER //
CREATE TRIGGER trg_AtualizaQuantidadeVenda
AFTER INSERT ON tblItensVenda
FOR EACH ROW
BEGIN
    UPDATE tbProduto 
    SET quantidadeProduto = quantidadeProduto - NEW.quantidadeItensVenda
    WHERE codProduto = NEW.codProduto;
END //
DELIMITER ;

-- Trigger para atualizar quantidade do produto após entrada
DELIMITER //
CREATE TRIGGER trg_AtualizaQuantidadeEntrada
AFTER INSERT ON tbEntradaProduto
FOR EACH ROW
BEGIN
    UPDATE tbProduto 
    SET quantidadeProduto = quantidadeProduto + NEW.quantidadeEntradaProduto
    WHERE codProduto = NEW.codProduto;
END //
DELIMITER ;

-- Trigger para registrar saída de produto após venda
DELIMITER //
CREATE TRIGGER trg_RegistraSaidaProduto
AFTER INSERT ON tblItensVenda
FOR EACH ROW
BEGIN
    INSERT INTO tbSaidaProduto (codSaidaProduto, dataSaidaProduto, codProduto, quantidadeSaidaProduto)
    SELECT 
        (SELECT COALESCE(MAX(codSaidaProduto), 0) + 1 FROM tbSaidaProduto),
        (SELECT dataVenda FROM tbVenda WHERE codVenda = NEW.codVenda),
        NEW.codProduto,
        NEW.quantidadeItensVenda;
END //
DELIMITER ; 