
CREATE TABLE Remedios (
    id_remedio INT PRIMARY KEY AUTO_INCREMENT,
    nome_remedio VARCHAR(100),
    preco_remedio DECIMAL(10, 2)
);

CREATE TABLE Diagnosticos (
    id_diagnostico INT PRIMARY KEY AUTO_INCREMENT,
    nome_diagnostico VARCHAR(100),
    preco_diagnostico DECIMAL(10, 2)
);

CREATE TABLE Atendimentos (
    id_atendimento INT PRIMARY KEY AUTO_INCREMENT,
    id_pet INT,
    id_remedio INT,
    id_diagnostico INT,
    data_atendimento DATE,
    observacoes TEXT,
    FOREIGN KEY (id_remedio) REFERENCES Remedios(id_remedio),
    FOREIGN KEY (id_diagnostico) REFERENCES Diagnosticos(id_diagnostico)
);

DELIMITER //

CREATE TRIGGER validar_preco_remedio BEFORE INSERT ON Remedios
FOR EACH ROW BEGIN
    IF NEW.preco_remedio < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O preço do remédio deve ser positivo.';
    END IF;
END //

DELIMITER ;

CREATE TRIGGER validar_preco_diagnostico BEFORE INSERT ON Diagnosticos
FOR EACH ROW BEGIN
    IF NEW.preco_diagnostico < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O preço do diagnóstico deve ser positivo.',
    END IF
END //

DELIMITER ;

CREATE TRIGGER validar_atendimento_data BEFORE INSERT ON Atendimentos
FOR EACH ROW BEGIN
    IF NEW.data_atendimento IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data do atendimento não pode ser nula.'
    END IF
END //

DELIMITER ;

CREATE TRIGGER registrar_insercao_remedio AFTER INSERT ON Remedios
FOR EACH ROW BEGIN
    INSERT INTO Log_Produtos (nome_remedio, tipo) VALUES (NEW.nome_remedio, 'Remédio')
END //

DELIMITER ;

CREATE TRIGGER registrar_insercao_diagnostico AFTER INSERT ON Diagnosticos
FOR EACH ROW BEGIN
    INSERT INTO Log_Produtos (nome_diagnostico, tipo) VALUES (NEW.nome_diagnostico, 'Diagnóstico')
END //

DELIMITER ;

CREATE PROCEDURE adicionar_remedio (
    IN p_nome_remedio VARCHAR(100),
    IN p_preco_remedio DECIMAL(10, 2)
) BEGIN
    INSERT INTO Remedios (nome_remedio, preco_remedio) VALUES (p_nome_remedio, p_preco_remedio)
END //

DELIMITER ;

CREATE PROCEDURE adicionar_diagnostico (
    IN p_nome_diagnostico VARCHAR(100),
    IN p_preco_diagnostico DECIMAL(10, 2)
) BEGIN
    INSERT INTO Diagnosticos (nome_diagnostico, preco_diagnostico) VALUES (p_nome_diagnostico, p_preco_diagnostico),
END //

DELIMITER ;

CREATE PROCEDURE registrar_atendimento (
    IN p_id_pet INT,
    IN p_id_remedio INT,
    IN p_id_diagnostico INT,
    IN p_data_atendimento DATE,
    IN p_observacoes TEXT
) BEGIN
    INSERT INTO Atendimentos (id_pet, id_remedio, id_diagnostico, data_atendimento, observacoes)
    VALUES (p_id_pet, p_id_remedio, p_id_diagnostico, p_data_atendimento, p_observacoes)
END //

DELIMITER ;

CREATE PROCEDURE listar_atendimentos_pet (
    IN p_id_pet INT
) BEGIN
    SELECT * FROM Atendimentos WHERE id_pet = p_id_pet
END //

DELIMITER ;

CREATE PROCEDURE remover_remedio (
    IN p_id_remedio INT
) BEGIN
    DELETE FROM Remedios WHERE id_remedio = p_id_remedio
END //

DELIMITER ;

-- Exemplo de chamadas
CALL adicionar_remedio('Antibiótico', 50.00);
CALL adicionar_diagnostico('Radiografia', 200.00);
CALL registrar_atendimento(1, 1, 1, '2024-09-24', 'Observações do atendimento');
CALL listar_atendimentos_pet(1);
CALL remover_remedio(1);
