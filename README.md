# Projekt Bazy Danych - System Zarządzania Reklamacjami

## Opis Projektu
### Projekt ma na celu utworzenie bazy danych wspierającej proces obsługi reklamacji klientów. Baza danych umożliwia:

Przechowywanie informacji o klientach (Customers), pracownikach (Employees), produktach (Products) oraz statusach reklamacji (Status).
Rejestrowanie zgłoszeń reklamacyjnych (Complaints) wraz ze szczegółami (ComplaintDetails).
Monitorowanie historii zmian statusów reklamacji (ComplaintsHistory).
Zarządzanie kosztami zwrotów (ReturnCosts).
Wspieranie operacji pomocniczych poprzez słowniki (CustomerTypes, EmployeePositions, PaymentMethods).
Współpracę z firmami zewnętrznymi (Companies) obsługującymi reklamacje.

## Tabele
### Tabele kluczowe 

**Customers** - dane o klientach, wraz z typem klienta.

**Employees** - dane o pracownikach, z przypisaniem stanowisk.

**Products** - dane o produktach.

**Status** - definicje statusów reklamacji.

**Complaints** - główne zgłoszenia reklamacyjne.

**ComplaintDetails** - szczegóły każdej reklamacji (opis, daty).

### Tabele typów oraz słowniki 

**CustomerTypes** - typy klientów (np. Standardowy, VIP).

**EmployeePositions** - stanowiska pracowników (np. Konsultant, Menedżer).

**Companies** - firmy zewnętrzne wspierające proces reklamacji.

**ComplaintsHistory** - tabela tymczasowa rejestrująca historię zmian statusów reklamacji.

**ReturnCosts** - informacje o kosztach zwrotu towarów.

**PaymentMethods** - słownik metod płatności (np. Karta, Przelew).

### Triggery

**trg_IDUpdate_*** - automatyczne nadawanie ID przy wstawianiu rekordów do tabel.

**trg_Complaints_StatusChange** - automatyczne rejestrowanie zmian statusu w ComplaintsHistory.

**trg_UpdateResolutionDate** (na Complaints) - automatyczna aktualizacja daty zakończenia w ComplaintDetails.

### Procedury 

**usp_InsertCustomer, usp_InsertEmployee, usp_InsertProduct, usp_InsertStatus, usp_InsertComplaint, usp_InsertComplaintDetail** - procedury do bezpiecznego wstawiania danych.

**usp_DeleteComplaint** - procedura do bezpiecznego usuwania reklamacji wraz ze szczegółami.

**usp_InsertCustomerType, usp_InsertEmployeePosition, usp_InsertCompany, usp_InsertReturnCost, usp_InsertPaymentMethod** - procedury do zarządzania nowo dodanymi tabelami.

## Uprawnienia oraz role  

**ROOT** - z przypisanym użytkownikiem ADMIN

**EMPLOYEE** - z przypisanym użytkownikiem WORKER


ROOT ma pełne prawa do SELECT, INSERT, UPDATE, DELETE na tabelach oraz EXECUTE na procedurach.

EMPLOYEE ma ograniczone uprawnienia, głównie do odczytu wybranych danych.
