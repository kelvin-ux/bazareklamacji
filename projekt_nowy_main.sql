USE zartuje;
GO

ALTER DATABASE [zartuje] SET RECOVERY FULL;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- ========================================
-- 1. Tabele
-- ========================================

CREATE TABLE [dbo].[Customers](
    [CustomerID] INT NOT NULL,
    [CustomerName] VARCHAR(50) NULL,
    [Contact] VARCHAR(20) NULL,
    [Address] VARCHAR(100) NULL,
    [City] VARCHAR(100) NULL,
    [PostalCode] VARCHAR(10) NULL,
    [Country] VARCHAR(50) NULL,
    CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
);
GO

CREATE TABLE [dbo].[Employees](
    [EmployeeID] INT NOT NULL,
    [LastName] VARCHAR(50) NULL,
    [FirstName] VARCHAR(50) NULL,
    [Email] VARCHAR(100) NULL,
    [PhoneNumber] VARCHAR(15) NULL,
    [HireDate] DATE NULL,
    [Salary] MONEY NULL,
    CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED ([EmployeeID] ASC)
);
GO

CREATE TABLE [dbo].[Products](
    [ProductID] INT NOT NULL,
    [ProductName] VARCHAR(50) NULL,
    [Unit] VARCHAR(20) NULL,
    [Price] MONEY NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductID] ASC)
);
GO

CREATE TABLE [dbo].[Status](
    [StatusID] INT NOT NULL,
    [StatusName] VARCHAR(50) NULL,
    CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED ([StatusID] ASC)
);
GO

CREATE TABLE [dbo].[Complaints](
    [ComplaintID] INT NOT NULL,
    [StatusID] INT NOT NULL,
    [CustomerID] INT NOT NULL,
    [EmployeeID] INT NOT NULL,
    [ProductID] INT NOT NULL,
    CONSTRAINT [PK_Complaints] PRIMARY KEY CLUSTERED ([ComplaintID] ASC)
);
GO

CREATE TABLE [dbo].[ComplaintDetails](
    [ComplaintID] INT NOT NULL,
    [Description] VARCHAR(500) NULL,
    [ComplaintDate] DATE NULL,
    [ResolutionDate] DATE NULL,
    CONSTRAINT [PK_ComplaintDetails] PRIMARY KEY CLUSTERED ([ComplaintID] ASC)
);
GO

CREATE TABLE [dbo].[CustomerTypes](
    [CustomerTypeID] INT NOT NULL,
    [CustomerTypeName] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_CustomerTypes] PRIMARY KEY CLUSTERED ([CustomerTypeID] ASC)
);
GO

CREATE TABLE [dbo].[EmployeePositions](
    [PositionID] INT NOT NULL,
    [PositionName] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_EmployeePositions] PRIMARY KEY CLUSTERED ([PositionID] ASC)
);
GO

CREATE TABLE [dbo].[Companies](
    [CompanyID] INT NOT NULL,
    [CompanyName] VARCHAR(100) NOT NULL,
    [Contact] VARCHAR(50) NULL,
    [Address] VARCHAR(100) NULL,
    [City] VARCHAR(50) NULL,
    [PostalCode] VARCHAR(10) NULL,
    [Country] VARCHAR(50) NULL,
    CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED ([CompanyID] ASC)
);
GO

CREATE TABLE [dbo].[ComplaintsHistory](
    [HistoryID] INT NOT NULL,
    [ComplaintID] INT NOT NULL,
    [OldStatusID] INT NULL,
    [NewStatusID] INT NULL,
    [ChangeDate] DATETIME NOT NULL,
    [ChangedByEmployeeID] INT NULL,
    CONSTRAINT [PK_ComplaintsHistory] PRIMARY KEY CLUSTERED ([HistoryID] ASC)
);
GO

CREATE TABLE [dbo].[ReturnCosts](
    [ReturnCostID] INT NOT NULL,
    [ComplaintID] INT NOT NULL,
    [ReturnFee] MONEY NOT NULL,
    [ReturnDate] DATE NULL,
    CONSTRAINT [PK_ReturnCosts] PRIMARY KEY CLUSTERED ([ReturnCostID] ASC)
);
GO

CREATE TABLE [dbo].[PaymentMethods](
    [PaymentMethodID] INT NOT NULL,
    [PaymentMethodName] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_PaymentMethods] PRIMARY KEY CLUSTERED ([PaymentMethodID] ASC)
);
GO


ALTER TABLE Customers ADD CustomerTypeID INT NULL;
ALTER TABLE Employees ADD PositionID INT NULL;



-- ========================================
-- 2. Klucze obce
-- ========================================

ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID]);

ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Employees] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID]);

ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID]);

ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Status] FOREIGN KEY([StatusID])
REFERENCES [dbo].[Status] ([StatusID]);

ALTER TABLE [dbo].[ComplaintDetails] WITH CHECK ADD CONSTRAINT [FK_ComplaintDetails_Complaints] FOREIGN KEY([ComplaintID])
REFERENCES [dbo].[Complaints] ([ComplaintID]);
GO

ALTER TABLE [dbo].[Customers] WITH CHECK ADD CONSTRAINT [FK_Customers_CustomerTypes] FOREIGN KEY([CustomerTypeID])
REFERENCES [dbo].[CustomerTypes] ([CustomerTypeID]);

ALTER TABLE [dbo].[Employees] WITH CHECK ADD CONSTRAINT [FK_Employees_EmployeePositions] FOREIGN KEY([PositionID])
REFERENCES [dbo].[EmployeePositions] ([PositionID]);

ALTER TABLE [dbo].[ComplaintsHistory] WITH CHECK ADD CONSTRAINT [FK_ComplaintsHistory_Complaints] FOREIGN KEY([ComplaintID])
REFERENCES [dbo].[Complaints]([ComplaintID]);

ALTER TABLE [dbo].[ComplaintsHistory] WITH CHECK ADD CONSTRAINT [FK_ComplaintsHistory_Employees] FOREIGN KEY([ChangedByEmployeeID])
REFERENCES [dbo].[Employees]([EmployeeID]);

ALTER TABLE [dbo].[ReturnCosts] WITH CHECK ADD CONSTRAINT [FK_ReturnCosts_Complaints] FOREIGN KEY([ComplaintID])
REFERENCES [dbo].[Complaints]([ComplaintID]);

-- ========================================
-- 3. Sekwencje do ID's
-- ========================================

CREATE SEQUENCE SEQ_Customers AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Employees AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Products AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Status AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Complaints AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ComplaintDetails AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_CustomerTypes AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_EmployeePositions AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Companies AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ComplaintsHistory AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ReturnCosts AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_PaymentMethods AS INT START WITH 1 INCREMENT BY 1;
GO

-- ========================================
-- 4. Triggery
-- ========================================

CREATE TRIGGER trg_IDUpdate_Customers
ON Customers
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Customers(CustomerID, CustomerName, Contact, Address, City, PostalCode, Country)
    SELECT NEXT VALUE FOR SEQ_Customers, CustomerName, Contact, Address, City, PostalCode, Country
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Employees
ON Employees
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Employees(EmployeeID, LastName, FirstName, Email, PhoneNumber, HireDate, Salary)
    SELECT NEXT VALUE FOR SEQ_Employees, LastName, FirstName, Email, PhoneNumber, HireDate, Salary
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Products
ON Products
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Products(ProductID, ProductName, Unit, Price)
    SELECT NEXT VALUE FOR SEQ_Products, ProductName, Unit, Price
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Status
ON Status
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Status(StatusID, StatusName)
    SELECT NEXT VALUE FOR SEQ_Status, StatusName
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Complaints
ON Complaints
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Complaints(ComplaintID, StatusID, CustomerID, EmployeeID, ProductID)
    SELECT NEXT VALUE FOR SEQ_Complaints, StatusID, CustomerID, EmployeeID, ProductID
    FROM inserted;
END;
GO

CREATE TRIGGER trg_UpdateResolutionDate
ON Complaints
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE cd
    SET ResolutionDate = GETDATE()
    FROM ComplaintDetails cd
    INNER JOIN inserted i ON cd.ComplaintID = i.ComplaintID
    WHERE i.StatusID = 4;  -- Zakoñczona
END;
GO

CREATE TRIGGER trg_IDUpdate_CustomerTypes
ON CustomerTypes
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO CustomerTypes(CustomerTypeID, CustomerTypeName)
    SELECT NEXT VALUE FOR SEQ_CustomerTypes, CustomerTypeName
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_EmployeePositions
ON EmployeePositions
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO EmployeePositions(PositionID, PositionName)
    SELECT NEXT VALUE FOR SEQ_EmployeePositions, PositionName
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Companies
ON Companies
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Companies(CompanyID, CompanyName, Contact, Address, City, PostalCode, Country)
    SELECT NEXT VALUE FOR SEQ_Companies, CompanyName, Contact, Address, City, PostalCode, Country
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_ComplaintsHistory
ON ComplaintsHistory
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO ComplaintsHistory(HistoryID, ComplaintID, OldStatusID, NewStatusID, ChangeDate, ChangedByEmployeeID)
    SELECT NEXT VALUE FOR SEQ_ComplaintsHistory, ComplaintID, OldStatusID, NewStatusID, ChangeDate, ChangedByEmployeeID
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_ReturnCosts
ON ReturnCosts
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO ReturnCosts(ReturnCostID, ComplaintID, ReturnFee, ReturnDate)
    SELECT NEXT VALUE FOR SEQ_ReturnCosts, ComplaintID, ReturnFee, ReturnDate
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_PaymentMethods
ON PaymentMethods
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO PaymentMethods(PaymentMethodID, PaymentMethodName)
    SELECT NEXT VALUE FOR SEQ_PaymentMethods, PaymentMethodName
    FROM inserted;
END;
GO

-- Trigger do historii modyfikacji Complaints na zmianê statusu
CREATE TRIGGER trg_Complaints_StatusChange
ON Complaints
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO ComplaintsHistory(ComplaintID, OldStatusID, NewStatusID, ChangeDate, ChangedByEmployeeID)
    SELECT 
        i.ComplaintID,
        d.StatusID AS OldStatusID,
        i.StatusID AS NewStatusID,
        GETDATE() AS ChangeDate,
        i.EmployeeID AS ChangedByEmployeeID
    FROM inserted i
    JOIN deleted d ON i.ComplaintID = d.ComplaintID
    WHERE i.StatusID <> d.StatusID;
END;
GO

-- ========================================
-- 5. Procedury
-- ========================================

CREATE PROCEDURE usp_InsertCustomer
    @CustomerName VARCHAR(50),
    @Contact VARCHAR(20),
    @Address VARCHAR(100),
    @City VARCHAR(100),
    @PostalCode VARCHAR(10),
    @Country VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Customers (CustomerName, Contact, Address, City, PostalCode, Country)
        VALUES (@CustomerName, @Contact, @Address, @City, @PostalCode, @Country);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertEmployee
    @LastName VARCHAR(50),
    @FirstName VARCHAR(50),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(15),
    @HireDate DATE,
    @Salary MONEY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Employees (LastName, FirstName, Email, PhoneNumber, HireDate, Salary)
        VALUES (@LastName, @FirstName, @Email, @PhoneNumber, @HireDate, @Salary);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertProduct
    @ProductName VARCHAR(50),
    @Unit VARCHAR(20),
    @Price MONEY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Products (ProductName, Unit, Price)
        VALUES (@ProductName, @Unit, @Price);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertStatus
    @StatusName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Status (StatusName)
        VALUES (@StatusName);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertComplaint
    @StatusID INT,
    @CustomerID INT,
    @EmployeeID INT,
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Complaints (StatusID, CustomerID, EmployeeID, ProductID)
        VALUES (@StatusID, @CustomerID, @EmployeeID, @ProductID);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertComplaintDetail
    @ComplaintID INT,
    @Description VARCHAR(500),
    @ComplaintDate DATE,
    @ResolutionDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO ComplaintDetails (ComplaintID, Description, ComplaintDate, ResolutionDate)
        VALUES (@ComplaintID, @Description, @ComplaintDate, @ResolutionDate);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_DeleteComplaint
    @ComplaintID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM ComplaintDetails WHERE ComplaintID = @ComplaintID;
        DELETE FROM Complaints WHERE ComplaintID = @ComplaintID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertCustomerType
    @CustomerTypeName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO CustomerTypes (CustomerTypeName)
        VALUES (@CustomerTypeName);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertEmployeePosition
    @PositionName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO EmployeePositions (PositionName)
        VALUES (@PositionName);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertCompany
    @CompanyName VARCHAR(100),
    @Contact VARCHAR(50),
    @Address VARCHAR(100),
    @City VARCHAR(50),
    @PostalCode VARCHAR(10),
    @Country VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Companies (CompanyName, Contact, Address, City, PostalCode, Country)
        VALUES (@CompanyName, @Contact, @Address, @City, @PostalCode, @Country);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertReturnCost
    @ComplaintID INT,
    @ReturnFee MONEY,
    @ReturnDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO ReturnCosts (ComplaintID, ReturnFee, ReturnDate)
        VALUES (@ComplaintID, @ReturnFee, @ReturnDate);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertPaymentMethod
    @PaymentMethodName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO PaymentMethods (PaymentMethodName)
        VALUES (@PaymentMethodName);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO




-- ========================================
-- 6. Przykladowe Dane & rekordy
-- ========================================

EXEC usp_InsertCustomer
    @CustomerName = 'Jan Kowalski',
    @Contact = '123-456-789',
    @Address = 'ul. G³ówna 1',
    @City = 'Warszawa',
    @PostalCode = '00-001',
    @Country = 'Polska';

EXEC usp_InsertCustomer
    @CustomerName = 'Maria Nowak',
    @Contact = '987-654-321',
    @Address = 'ul. Kwiatowa 5',
    @City = 'Kraków',
    @PostalCode = '30-001',
    @Country = 'Polska';

EXEC usp_InsertEmployee
    @LastName = 'Nowak',
    @FirstName = 'Anna',
    @Email = 'anna.nowak@example.com',
    @PhoneNumber = '987-654-321',
    @HireDate = '2024-01-15',
    @Salary = 4000.00;

EXEC usp_InsertEmployee
    @LastName = 'Kowalski',
    @FirstName = 'Piotr',
    @Email = 'piotr.kowalski@example.com',
    @PhoneNumber = '123-456-789',
    @HireDate = '2024-02-20',
    @Salary = 4500.00;

EXEC usp_InsertProduct
    @ProductName = 'Jajka',
    @Unit = 'szt.',
    @Price = 99.99;

EXEC usp_InsertProduct
    @ProductName = 'Wo³owina',
    @Unit = 'kg',
    @Price = 49.99;

EXEC usp_InsertStatus @StatusName = 'Nowa';
EXEC usp_InsertStatus @StatusName = 'Oczekuje na pracownika';
EXEC usp_InsertStatus @StatusName = 'W trakcie';
EXEC usp_InsertStatus @StatusName = 'Zakoñczona';

EXEC usp_InsertComplaint
    @StatusID = 1,     -- 'Nowa'
    @CustomerID = 1,   -- 'Jan Kowalski'
    @EmployeeID = 1,   -- 'Anna Nowak'
    @ProductID = 1;    -- 'Jajka'

EXEC usp_InsertComplaint
    @StatusID = 2,     -- 'Oczekuje na pracownika'
    @CustomerID = 2,   -- 'Maria Nowak'
    @EmployeeID = 2,   -- 'Piotr Kowalski'
    @ProductID = 2;    -- 'Wo³owina'

--brak customer id -- test bledu
-- EXEC usp_InsertComplaint
--     @StatusID = 1,
--     @CustomerID = 99,   
--     @EmployeeID = 1,
--     @ProductID = 1;

EXEC usp_InsertComplaintDetail
    @ComplaintID = 1,
    @Description = 'Produkt uszkodzony podczas transportu.',
    @ComplaintDate = '2024-01-15';

EXEC usp_InsertComplaintDetail
    @ComplaintID = 2,
    @Description = 'Brak jednego elementu w zestawie.',
    @ComplaintDate = '2024-02-10';



-- Customers 

EXEC usp_InsertCustomer @CustomerName = 'Jan Kowalski',      @Contact = '123-456-001', @Address = 'ul. G³ówna 1',    @City = 'Warszawa',   @PostalCode = '00-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Maria Nowak',       @Contact = '123-456-002', @Address = 'ul. Kwiatowa 5',  @City = 'Kraków',     @PostalCode = '30-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Piotr Wiœniewski',  @Contact = '123-456-003', @Address = 'ul. Leœna 12',    @City = 'Gdañsk',     @PostalCode = '80-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Anna Zieliñska',    @Contact = '123-456-004', @Address = 'ul. Polna 3',     @City = 'Poznañ',     @PostalCode = '60-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Krzysztof Wójcik',  @Contact = '123-456-005', @Address = 'ul. S³oneczna 7', @City = 'Wroc³aw',    @PostalCode = '50-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Barbara Kowalczyk', @Contact = '123-456-006', @Address = 'ul. Krótka 9',    @City = '£ódŸ',       @PostalCode = '90-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Tomasz Kamiñski',   @Contact = '123-456-007', @Address = 'ul. D³uga 15',    @City = 'Lublin',     @PostalCode = '20-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Agnieszka Lewandowska', @Contact = '123-456-008', @Address = 'ul. Weso³a 2', @City = 'Katowice', @PostalCode = '40-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Micha³ WoŸniak',    @Contact = '123-456-009', @Address = 'ul. Krucza 8',    @City = 'Szczecin',   @PostalCode = '70-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Ewa Szymañska',     @Contact = '123-456-010', @Address = 'ul. W¹ska 4',     @City = 'Bydgoszcz',  @PostalCode = '85-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Pawe³ D¹browski',   @Contact = '123-456-011', @Address = 'ul. Ró¿ana 6',    @City = 'Bia³ystok',  @PostalCode = '15-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Magdalena Koz³owska', @Contact = '123-456-012', @Address = 'ul. Lipowa 11', @City = 'Gdynia',    @PostalCode = '81-001', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Adam Jankowski',    @Contact = '123-456-013', @Address = 'ul. Œwierkowa 13',@City = 'Czêstochowa',@PostalCode = '42-200', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Joanna Mazur',      @Contact = '123-456-014', @Address = 'ul. Morska 17',   @City = 'Radom',      @PostalCode = '26-600', @Country = 'Polska';
EXEC usp_InsertCustomer @CustomerName = 'Grzegorz Krawczyk', @Contact = '123-456-015', @Address = 'ul. Zamkowa 21',  @City = 'Sosnowiec',  @PostalCode = '41-200', @Country = 'Polska';

-- Employees

EXEC usp_InsertEmployee @LastName = 'Nowak',       @FirstName = 'Anna',      @Email = 'anna.nowak@example.com',        @PhoneNumber = '987-654-001', @HireDate = '2023-01-01', @Salary = 4000.00;
EXEC usp_InsertEmployee @LastName = 'Kowalski',    @FirstName = 'Piotr',     @Email = 'piotr.kowalski@example.com',     @PhoneNumber = '987-654-002', @HireDate = '2023-02-01', @Salary = 4200.00;
EXEC usp_InsertEmployee @LastName = 'Wiœniewski',  @FirstName = 'Marek',     @Email = 'marek.wisniewski@example.com',   @PhoneNumber = '987-654-003', @HireDate = '2023-03-01', @Salary = 4300.00;
EXEC usp_InsertEmployee @LastName = 'Wójcik',      @FirstName = 'Tomasz',    @Email = 'tomasz.wojcik@example.com',      @PhoneNumber = '987-654-004', @HireDate = '2023-04-01', @Salary = 4400.00;
EXEC usp_InsertEmployee @LastName = 'Kowalczyk',   @FirstName = 'Katarzyna', @Email = 'katarzyna.kowalczyk@example.com',@PhoneNumber = '987-654-005', @HireDate = '2023-05-01', @Salary = 4500.00;
EXEC usp_InsertEmployee @LastName = 'Kamiñski',    @FirstName = 'Pawe³',     @Email = 'pawel.kaminski@example.com',     @PhoneNumber = '987-654-006', @HireDate = '2023-06-01', @Salary = 4600.00;
EXEC usp_InsertEmployee @LastName = 'Lewandowski', @FirstName = 'Andrzej',   @Email = 'andrzej.lewandowski@example.com',@PhoneNumber = '987-654-007', @HireDate = '2023-07-01', @Salary = 4700.00;
EXEC usp_InsertEmployee @LastName = 'Zieliñski',   @FirstName = 'Jan',       @Email = 'jan.zielinski@example.com',      @PhoneNumber = '987-654-008', @HireDate = '2023-08-01', @Salary = 4800.00;
EXEC usp_InsertEmployee @LastName = 'Szymañska',   @FirstName = 'Monika',    @Email = 'monika.szymanska@example.com',   @PhoneNumber = '987-654-009', @HireDate = '2023-09-01', @Salary = 4900.00;
EXEC usp_InsertEmployee @LastName = 'WoŸniak',     @FirstName = 'Ewa',       @Email = 'ewa.wozniak@example.com',        @PhoneNumber = '987-654-010', @HireDate = '2023-10-01', @Salary = 5000.00;
EXEC usp_InsertEmployee @LastName = 'D¹browski',   @FirstName = 'Micha³',    @Email = 'michal.dabrowski@example.com',   @PhoneNumber = '987-654-011', @HireDate = '2023-11-01', @Salary = 5100.00;
EXEC usp_InsertEmployee @LastName = 'Koz³owska',   @FirstName = 'Agnieszka', @Email = 'agnieszka.kozlowska@example.com',@PhoneNumber = '987-654-012', @HireDate = '2023-12-01', @Salary = 5200.00;
EXEC usp_InsertEmployee @LastName = 'Jankowski',   @FirstName = 'Adam',      @Email = 'adam.jankowski@example.com',     @PhoneNumber = '987-654-013', @HireDate = '2024-01-01', @Salary = 5300.00;
EXEC usp_InsertEmployee @LastName = 'Mazur',       @FirstName = 'Joanna',    @Email = 'joanna.mazur@example.com',       @PhoneNumber = '987-654-014', @HireDate = '2024-02-01', @Salary = 5400.00;
EXEC usp_InsertEmployee @LastName = 'Krawczyk',    @FirstName = 'Grzegorz',  @Email = 'grzegorz.krawczyk@example.com',  @PhoneNumber = '987-654-015', @HireDate = '2024-03-01', @Salary = 5500.00;

-- Products

EXEC usp_InsertProduct @ProductName = 'Smartfon',     @Unit = 'szt.', @Price = 2000.00;
EXEC usp_InsertProduct @ProductName = 'Laptop',       @Unit = 'szt.', @Price = 3500.00;
EXEC usp_InsertProduct @ProductName = 'Telewizor',    @Unit = 'szt.', @Price = 2500.00;
EXEC usp_InsertProduct @ProductName = 'S³uchawki',    @Unit = 'szt.', @Price = 150.00;
EXEC usp_InsertProduct @ProductName = 'Klawiatura',   @Unit = 'szt.', @Price = 100.00;
EXEC usp_InsertProduct @ProductName = 'Myszka',       @Unit = 'szt.', @Price = 80.00;
EXEC usp_InsertProduct @ProductName = 'Monitor',      @Unit = 'szt.', @Price = 800.00;
EXEC usp_InsertProduct @ProductName = 'Tablet',       @Unit = 'szt.', @Price = 1800.00;
EXEC usp_InsertProduct @ProductName = 'Kamera',       @Unit = 'szt.', @Price = 1200.00;
EXEC usp_InsertProduct @ProductName = 'G³oœnik',      @Unit = 'szt.', @Price = 300.00;
EXEC usp_InsertProduct @ProductName = 'Drukarka',     @Unit = 'szt.', @Price = 600.00;
EXEC usp_InsertProduct @ProductName = 'Dysk twardy',  @Unit = 'szt.', @Price = 250.00;
EXEC usp_InsertProduct @ProductName = 'Pendrive',     @Unit = 'szt.', @Price = 50.00;
EXEC usp_InsertProduct @ProductName = 'Kabel HDMI',   @Unit = 'szt.', @Price = 30.00;
EXEC usp_InsertProduct @ProductName = '£adowarka',    @Unit = 'szt.', @Price = 40.00;


-- ComplaintDetails

EXEC usp_InsertComplaintDetail @ComplaintID = 1,  @Description = 'Produkt uszkodzony w transporcie',              @ComplaintDate = '2024-01-01'
EXEC usp_InsertComplaintDetail @ComplaintID = 2,  @Description = 'Brak instrukcji obs³ugi',                       @ComplaintDate = '2024-01-02'
EXEC usp_InsertComplaintDetail @ComplaintID = 3,  @Description = 'Niekompletny zestaw',                          @ComplaintDate = '2024-01-03'
EXEC usp_InsertComplaintDetail @ComplaintID = 4,  @Description = 'Produkt niezgodny z opisem',                    @ComplaintDate = '2024-01-04'
EXEC usp_InsertComplaintDetail @ComplaintID = 5,  @Description = 'OpóŸniona dostawa',                            @ComplaintDate = '2024-01-05'
EXEC usp_InsertComplaintDetail @ComplaintID = 6,  @Description = 'Problem z p³atnoœci¹',                         @ComplaintDate = '2024-01-06',                     @ResolutionDate='2024-01-15'
EXEC usp_InsertComplaintDetail @ComplaintID = 7,  @Description = 'B³êdne dane na fakturze',                      @ComplaintDate = '2024-01-07'
EXEC usp_InsertComplaintDetail @ComplaintID = 8,  @Description = 'Uszkodzone opakowanie',                        @ComplaintDate = '2024-01-08'
EXEC usp_InsertComplaintDetail @ComplaintID = 9,  @Description = 'Nie dzia³a kod rabatowy',                      @ComplaintDate = '2024-01-09',						@ResolutionDate='2024-01-18'
EXEC usp_InsertComplaintDetail @ComplaintID = 10, @Description = 'Z³y kolor produktu',                           @ComplaintDate = '2024-01-10'
EXEC usp_InsertComplaintDetail @ComplaintID = 11, @Description = 'Niedzia³aj¹cy produkt',                        @ComplaintDate = '2024-01-11'
EXEC usp_InsertComplaintDetail @ComplaintID = 12, @Description = 'Brak zwrotu pieniêdzy',                        @ComplaintDate = '2024-01-12', 					@ResolutionDate='2024-01-27'
EXEC usp_InsertComplaintDetail @ComplaintID = 13, @Description = 'Z³y rozmiar produktu',                         @ComplaintDate = '2024-01-13'
EXEC usp_InsertComplaintDetail @ComplaintID = 14, @Description = 'Problem z rejestracj¹ konta',                  @ComplaintDate = '2024-01-14'
EXEC usp_InsertComplaintDetail @ComplaintID = 15, @Description = 'Nieprawid³owy numer œledzenia przesy³ki',      @ComplaintDate = '2024-01-15',						@ResolutionDate='2024-01-27'

--  Complaints

EXEC usp_InsertComplaint @StatusID = 1,  @CustomerID = 1,  @EmployeeID = 1,  @ProductID = 1;
EXEC usp_InsertComplaint @StatusID = 2,  @CustomerID = 2,  @EmployeeID = 2,  @ProductID = 2;
EXEC usp_InsertComplaint @StatusID = 3,  @CustomerID = 3,  @EmployeeID = 3,  @ProductID = 3;
EXEC usp_InsertComplaint @StatusID = 4,  @CustomerID = 4,  @EmployeeID = 4,  @ProductID = 4;
EXEC usp_InsertComplaint @StatusID = 1,  @CustomerID = 5,  @EmployeeID = 5,  @ProductID = 5;
EXEC usp_InsertComplaint @StatusID = 2,  @CustomerID = 6,  @EmployeeID = 6,  @ProductID = 6;
EXEC usp_InsertComplaint @StatusID = 3,  @CustomerID = 7,  @EmployeeID = 7,  @ProductID = 7;
EXEC usp_InsertComplaint @StatusID = 4,  @CustomerID = 8,  @EmployeeID = 8,  @ProductID = 8;
EXEC usp_InsertComplaint @StatusID = 1,  @CustomerID = 9,  @EmployeeID = 9,  @ProductID = 9;
EXEC usp_InsertComplaint @StatusID = 2, @CustomerID = 10, @EmployeeID = 10, @ProductID = 10;
EXEC usp_InsertComplaint @StatusID = 3, @CustomerID = 11, @EmployeeID = 11, @ProductID = 11;
EXEC usp_InsertComplaint @StatusID = 4, @CustomerID = 12, @EmployeeID = 12, @ProductID = 12;
EXEC usp_InsertComplaint @StatusID = 3, @CustomerID = 13, @EmployeeID = 13, @ProductID = 13;
EXEC usp_InsertComplaint @StatusID = 4, @CustomerID = 14, @EmployeeID = 14, @ProductID = 14;
EXEC usp_InsertComplaint @StatusID = 1, @CustomerID = 15, @EmployeeID = 15, @ProductID = 15;


EXEC usp_InsertCustomerType @CustomerTypeName = 'Standardowy';
EXEC usp_InsertCustomerType @CustomerTypeName = 'VIP';
EXEC usp_InsertEmployeePosition @PositionName = 'Konsultant';
EXEC usp_InsertEmployeePosition @PositionName = 'Mened¿er';
EXEC usp_InsertPaymentMethod @PaymentMethodName = 'Karta Kredytowa';
EXEC usp_InsertPaymentMethod @PaymentMethodName = 'Przelew Bankowy';

EXEC usp_InsertCompany 
    @CompanyName='Reklamacje Sp. z o.o.', 
    @Contact='reklamacje@firma.pl', 
    @Address='ul. Naprawcza 10',
    @City='Warszawa',
    @PostalCode='00-999',
    @Country='Polska';



SELECT * FROM Customers;
SELECT * FROM Employees;
SELECT * FROM Products;
SELECT * FROM Status;
SELECT * FROM Complaints;
SELECT * FROM ComplaintDetails;
SELECT * FROM Companies;
SELECT * FROM EmployeePositions;
SELECT * FROM CustomerTypes;
SELECT * FROM ComplaintsHistory;
SELECT * FROM ReturnCosts;
SELECT * FROM PaymentMethods;


EXEC usp_InsertReturnCost @ComplaintID=1, @ReturnFee=50.00, @ReturnDate='2024-03-01';


truncate table ComplaintDetails;


UPDATE Complaints
SET StatusID = 4 
WHERE ComplaintID = 1;

SELECT * FROM ComplaintDetails WHERE ComplaintID = 1;

EXEC usp_DeleteComplaint @ComplaintID = 2;

SELECT * FROM Complaints WHERE ComplaintID = 2;
SELECT * FROM ComplaintDetails WHERE ComplaintID = 2;

UPDATE Customers SET CustomerTypeID = 1 WHERE CustomerID = 1;

UPDATE Employees SET PositionID = 1 WHERE EmployeeID = 1;


-- ========================================
-- 9. Loginy, has³a oraz permisje dla grup uzytkowników
-- ========================================

CREATE LOGIN [ADMIN] WITH PASSWORD = 'RootPass1!';
CREATE LOGIN [WORKER] WITH PASSWORD = 'WorkerPass1!';

CREATE USER [ADMIN] FOR LOGIN [ADMIN];
CREATE USER [WORKER] FOR LOGIN [WORKER];

CREATE ROLE [ROOT];
CREATE ROLE [EMPLOYEE];

EXEC sp_addrolemember 'ROOT', 'ADMIN';
EXEC sp_addrolemember 'EMPLOYEE', 'WORKER';

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Customers] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Employees] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Products] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Status] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Complaints] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[ComplaintDetails] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[CustomerTypes] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[EmployeePositions] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Companies] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[ComplaintsHistory] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[ReturnCosts] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[PaymentMethods] TO [ROOT];

GRANT EXECUTE ON [dbo].[usp_InsertCustomer] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertEmployee] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertProduct] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertStatus] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertComplaint] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertComplaintDetail] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_DeleteComplaint] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertCustomerType] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertEmployeePosition] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertCompany] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertReturnCost] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertPaymentMethod] TO [ROOT];

GRANT SELECT ON [dbo].[Customers] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Employees] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Products] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Status] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Complaints] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[ComplaintDetails] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[CustomerTypes] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[EmployeePositions] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Companies] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[ComplaintsHistory] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[ReturnCosts] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[PaymentMethods] TO [EMPLOYEE];

-- ========================================
-- 10. Backup Bazy Danych
-- ========================================

BACKUP DATABASE [zartuje]
TO DISK = 'C:\bu\zartuje_FULL.bak'
WITH INIT;
GO

-- ========================================
-- 11. Przywracanie Bazy Danych z loginem sa
-- ========================================

-- Restore Database Command (Adjust Paths as Needed)
-- RESTORE DATABASE [zartuje]
-- FROM DISK = 'C:\bu\zartuje_FULL.bak'
-- WITH REPLACE,
-- MOVE 'zartuje_Data' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\zartuje.mdf',
-- MOVE 'zartuje_Log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\zartuje_log.ldf';
-- GO

-- ========================================
-- 12. Przyklady uzycia
-- ========================================


-- Lista wszystkich reklamacji
SELECT
    c.ComplaintID,
    cu.CustomerName,
    p.ProductName,
    s.StatusName,
    cd.ComplaintDate
FROM
    Complaints c
    INNER JOIN Customers cu ON c.CustomerID = cu.CustomerID
    INNER JOIN Products p ON c.ProductID = p.ProductID
    INNER JOIN Status s ON c.StatusID = s.StatusID
	INNER JOIN ComplaintDetails cd on c.ComplaintID = cd.ComplaintID;

-- Lista reklamacji w stosunku do aktualnego Statusu 

SELECT
    s.StatusName,
    COUNT(*) AS LiczbaReklamacji
FROM
    Complaints c
    INNER JOIN Status s ON c.StatusID = s.StatusID
GROUP BY
    s.StatusName;

-- Lista z liczb¹ reklamacji dla konkretnego klienta

SELECT
    c.ComplaintID,
    cd.Description,
    cd.ResolutionDate
FROM
    Complaints c
    INNER JOIN ComplaintDetails cd ON c.ComplaintID = cd.ComplaintID
WHERE
    c.CustomerID = 1;


-- Widok z list¹ reklamacji obsluzonych przez konkretnych pracownikow 
GO
CREATE VIEW vw_zartujePracownicy AS
SELECT
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    COUNT(c.ComplaintID) AS LiczbaReklamacji
FROM
    Complaints c
    INNER JOIN Employees e ON c.EmployeeID = e.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName;
GO

SELECT * FROM vw_zartujePracownicy;

-- Sredni czas realizacji zamowienia
WITH ComplaintDurations AS (
    SELECT
        c.ComplaintID,
        cd.ComplaintDate AS StartDate,
        cd.ResolutionDate AS EndDate
    FROM
        Complaints c
        INNER JOIN ComplaintDetails cd ON c.ComplaintID = cd.ComplaintID
    WHERE
        cd.ResolutionDate IS NOT NULL
)
SELECT
    AVG(DATEDIFF(day, StartDate, EndDate)) AS SredniCzasObslugi
FROM
    ComplaintDurations;
GO 
CREATE VIEW vw_ComplaintsByStatus AS
SELECT 
    s.StatusName, 
    COUNT(c.ComplaintID) AS ComplaintCount
FROM 
    Status s
LEFT JOIN 
    Complaints c ON s.StatusID = c.StatusID
GROUP BY 
    s.StatusName;
GO

Select * from vw_ComplaintsByStatus;
GO
CREATE VIEW vw_ComplaintResolutionTime AS
SELECT 
    cd.ComplaintID,
    cu.CustomerName,
    p.ProductName,
    DATEDIFF(DAY, cd.ComplaintDate, cd.ResolutionDate) AS ResolutionTimeDays
FROM 
    ComplaintDetails cd
JOIN 
    Complaints c ON cd.ComplaintID = c.ComplaintID
JOIN 
    Customers cu ON c.CustomerID = cu.CustomerID
JOIN 
    Products p ON c.ProductID = p.ProductID;
GO
select * from vw_ComplaintResolutionTime

SELECT 
    rc.ReturnCostID, 
    c.ComplaintID, 
    cu.CustomerName, 
    rc.ReturnFee, 
    rc.ReturnDate
FROM ReturnCosts rc
JOIN Complaints c ON rc.ComplaintID = c.ComplaintID
JOIN Customers cu ON c.CustomerID = cu.CustomerID;

-- Historia zmian statusów reklamacji
SELECT 
    ch.HistoryID, 
    ch.ComplaintID, 
    s1.StatusName AS OldStatus, 
    s2.StatusName AS NewStatus, 
    ch.ChangeDate,
    e.FirstName + ' ' + e.LastName AS ChangedBy
FROM ComplaintsHistory ch
LEFT JOIN Status s1 ON ch.OldStatusID = s1.StatusID
LEFT JOIN Status s2 ON ch.NewStatusID = s2.StatusID
LEFT JOIN Employees e ON ch.ChangedByEmployeeID = e.EmployeeID;

-- Klienci z typem
SELECT 
    cu.CustomerName, 
    ct.CustomerTypeName 
FROM Customers cu
LEFT JOIN CustomerTypes ct ON cu.CustomerTypeID = ct.CustomerTypeID;

-- Pracownicy ze stanowiskiem
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    ep.PositionName
FROM Employees e
LEFT JOIN EmployeePositions ep ON e.PositionID = ep.PositionID;