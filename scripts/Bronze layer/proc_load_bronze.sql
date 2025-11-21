/*
================================================================================
Stored Procedure: Load Bronze layer data
________________________________________________________________________________
Script purpose:
	The store procedure load data from csv files from CRM and ERP sytems

Actions Performed: 
	Truncates bronze tables.
	Load data from source files into the bronze layer tables

Parameters:
	none

Usage Example:
	EXEC bronze.load_bronze;
 ===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	
	DECLARE @start_time datetime, @end_time datetime, @batch_start_time datetime, @bactch_end_time datetime
	SET @batch_start_time  = GETDATE();
	Begin try
		Print '=======================================';
		Print 'Truncating and Loading CRM data';
		Print '=======================================';
	
		SET @start_time = GETDATE();
		Print '>> Truncating crm_cust_info data '
		TRUNCATE TABLE Bronze.crm_cust_info;
		Print '>> Loading crm_cust_info data '
		BULK INSERT Bronze.crm_cust_info
		from 'C:\Users\DELL\Downloads\data warehouse\source_crm\cust_info.csv'
		with
		(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE();
		PRINT '>> Load durarion: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'

		SET @start_time = GETDATE()
		Print '>> Truncating crm_prd_info data '
		TRUNCATE TABLE Bronze.crm_prd_info;
		Print '>> Loading crm_prd_info data '
		BULK INSERT Bronze.crm_prd_info
		from 'C:\Users\DELL\Downloads\data warehouse\source_crm\prd_info.csv'
		with
		(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE();
		PRINT '>> Load durarion: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'

		SET @start_time = GETDATE()
		Print '>> Truncating crm_sales_details data '
		TRUNCATE TABLE Bronze.crm_sales_details;
		Print '>> Loading crm_prd_sales_details '
		BULK INSERT Bronze.crm_sales_details
		from 'C:\Users\DELL\Downloads\data warehouse\source_crm\sales_details.csv'
		with
		(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE();
		PRINT '>> Load durarion: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'

		Print '=======================================';
		Print 'Truncating and Loading ERP data';
		Print '=======================================';

		SET @start_time = GETDATE()
		Print '>> Truncating erp_cust_aZ12 data '
		TRUNCATE TABLE Bronze.erp_cust_aZ12;
		Print '>> Loading erp_cust_aZ12 '
		BULK INSERT Bronze.erp_cust_aZ12
		from 'C:\Users\DELL\Downloads\data warehouse\source_erp\cust_aZ12.csv'
		with
		(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE();
		PRINT '>> Load durarion: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'

		SET @start_time = GETDATE()
		Print '>> Truncating erp_loc_a101 data '
		TRUNCATE TABLE Bronze.erp_loc_a101;
		Print '>> Loading erp_loc_a101 '
		BULK INSERT Bronze.erp_loc_a101
		from 'C:\Users\DELL\Downloads\data warehouse\source_erp\loc_a101.csv'
		with
		(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE();
		PRINT '>> Load durarion: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'

		SET @start_time = GETDATE()
		Print '>> Truncating erp_px_cat_g1v2 data '
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
		Print '>> Loading erp_px_cat_g1v2'
		BULK INSERT Bronze.erp_px_cat_g1v2
		from 'C:\Users\DELL\Downloads\data warehouse\source_erp\px_cat_g1v2.csv'
		with
		(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE();
		PRINT '>> Load durarion: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
	Print '============================================='
	SET @bactch_end_time = GETDATE()
	Print 'Bronze layer data truncate and load completed'
	PRINT '>> Total Load durarion: ' + CAST(DATEDIFF(second,@batch_start_time,@bactch_end_time) AS NVARCHAR) + ' seconds'
	Print '============================================='
	END TRY
	BEGIN CATCH

	Print '============================================='
	Print 'Truncate and loading error Bronze Layer'
	Print 'Error message: ' + Error_message()
	Print 'Error message: ' + cast(Error_number() as nvarchar)
	Print 'Error message: ' + cast(Error_state() as nvarchar)
	Print '============================================='

	END CATCH
END;
go


