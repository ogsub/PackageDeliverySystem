package rs.etf.sab;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import rs.etf.sab.operations.GeneralOperations;

public class GeneralOperationsConcrete implements GeneralOperations {

	private Connection connection = DB.getInstance().getConnection();
	
	@Override
	public void eraseAll() {
		try (PreparedStatement ps = connection.prepareStatement(""
				+ "DELETE FROM [TransportPaketa].[dbo].[Ponuda] "
				+ "DELETE FROM [TransportPaketa].[dbo].[ZahtevZaPrevoz] "
				+ "DELETE FROM [TransportPaketa].[dbo].[Opstina]   "
				
				+ "DELETE FROM [TransportPaketa].[dbo].[Administrator] "
				+ "DELETE FROM [TransportPaketa].[dbo].[ZahtevAdminu] "
				+ "DELETE FROM [TransportPaketa].[dbo].[Korisnik] "
				+ "DELETE FROM [TransportPaketa].[dbo].[Kurir] "
				+ "DELETE FROM [TransportPaketa].[dbo].[Grad] "
				
				+ "DELETE FROM [TransportPaketa].[dbo].[Vozilo] "
				);
				){
			ps.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
