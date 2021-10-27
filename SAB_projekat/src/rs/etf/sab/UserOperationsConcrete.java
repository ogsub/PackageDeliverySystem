package rs.etf.sab;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import org.junit.Assert;

import rs.etf.sab.operations.CityOperations;
import rs.etf.sab.operations.DistrictOperations;
import rs.etf.sab.operations.UserOperations;

public class UserOperationsConcrete implements UserOperations {

	private Connection connection = DB.getInstance().getConnection();

	@Override
	public int declareAdmin(String userName) {
		try (PreparedStatement ps = connection.prepareStatement("select KorIme from Administrator where KorIme = ?");){
			
			ps.setString(1, userName);
			try (ResultSet rs = ps.executeQuery();){
				//if already admin ret 1
				if(rs.next()) {
					return 1;
				}
				
				try(PreparedStatement ps2 = connection.prepareStatement("select KorIme from Korisnik where KorIme = ?");){
					ps2.setString(1, userName);
					try(ResultSet rs2 = ps2.executeQuery();){
						if(rs2.next()) {
							try (PreparedStatement ps3 = connection.prepareStatement("INSERT INTO Administrator (KorIme) VALUES (?)")){
								ps3.setString(1, userName);
								ps3.executeUpdate();
								//success
								return 0;
							} catch (Exception e) {
								// TODO: handle exception
							}
						}
						else {
							//no user with that username
							return 2;
						}
					}catch (Exception e) {
						// TODO: handle exception
					}
				}catch (Exception e) {
					// TODO: handle exception
				}
			} catch (Exception e) {
				// TODO: handle exception
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public int deleteUsers(String... userNames) {
		int numDeleted = 0;
		try (PreparedStatement ps = connection.prepareStatement("  DELETE FROM Korisnik WHERE KorIme = ?");) {
			for (String s : userNames) {
				ps.setString(1, s);
				int rowsAffected = ps.executeUpdate();
				numDeleted += rowsAffected;
			}
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return numDeleted;
	}

	@Override
	public List<String> getAllUsers() {
		List<String> listaPrimarnihKljuceva = new ArrayList<String>();
		try (PreparedStatement ps = connection.prepareStatement("select KorIme from Korisnik");
				ResultSet rs = ps.executeQuery();) {

			while (rs.next()) {
				listaPrimarnihKljuceva.add(rs.getString(1));
			}
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public Integer getSentPackages(String... userNames) {
//		String sqlCheck = "select KorIme from Korisnik";
//		boolean found = false;
//		
//		try (PreparedStatement psCheck = connection.prepareStatement("select KorIme from Korisnik");
//				ResultSet rs = psCheck.executeQuery();){
//			while(rs.next()) {
//				//if(userNames.rs.getString(1))
//			}
//		} catch (Exception e) {
//			// TODO: handle exception
//		}
		
		String sql = "select coalesce(sum(BrPoslatihPaketa), -1) from Korisnik where KorIme in (";
		if(userNames.length > 0) {
			for(int i = 0; i < userNames.length - 1; i++) {
				sql += "?,";
			}
			sql += "?)";
		}
		
		try (PreparedStatement ps = connection.prepareStatement(sql);) {
			for (int i = 0; i < userNames.length; i++) {
				ps.setString(i + 1, userNames[i]);
			}
			
			try (ResultSet rs = ps.executeQuery()){
				if(rs.next()) {
					int res = rs.getInt(1);
					return res == -1 ? null : res;
				}
				else {
					return null;
				}
			} catch (Exception e) {
				// TODO: handle exception
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}

	@Override
	public boolean insertUser(String userName, String firstName, String lastName, String password) {
		if (!Character.isUpperCase(firstName.charAt(0)) || !Character.isUpperCase(lastName.charAt(0))){
			return false;
		}
		
		if(password.length() < 8) {
			return false;
		}
		
		if (!Pattern.compile("[0-9]").matcher(password).find()) {
			return false;
		}
		
		if (!(Pattern.compile("[a-z]").matcher(password).find() || Pattern.compile("[A-Z]").matcher(password).find())) {
			return false;
		}
		
		try (PreparedStatement ps = connection.prepareStatement(
				"INSERT INTO Korisnik (KorIme, Ime, Prezime, Sifra, BrPoslatihPaketa) VALUES (?,?,?,?,0)");) {
			ps.setString(1, userName);
			ps.setString(2, firstName);
			ps.setString(3, lastName);
			ps.setString(4, password);

			// System.out.println("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" + userName);

			ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			// e.printStackTrace();
		}
		return false;
	}

	public static void main(String[] args) {

//        CityOperations cityOperations = new so170425_CityOperations();
//        DistrictOperations districtOperations = new so170425_DistrictOperations();
        GeneralOperationsConcrete general = new GeneralOperationsConcrete();
        UserOperations userOperations = new UserOperationsConcrete();
        
        general.eraseAll();
        
        String username = "crno.dete";
        String firstName = "Svetislav";
        String lastName = "Kisprdilov";
        String password = "sisatovac123";
        Assert.assertTrue(userOperations.insertUser(username, firstName, lastName, password));
  
    
        general.eraseAll();

        username = "rope";
        firstName = "Pero";
        lastName = "Simic";
        password = "tralalalala123";
        userOperations.insertUser(username, firstName, lastName, password);
        Assert.assertEquals(0L, userOperations.declareAdmin(username));
  
        general.eraseAll();

        Assert.assertEquals(2L, userOperations.declareAdmin("Nana"));
        
        general.eraseAll();

        username = "rope";
        firstName = "Pero";
        lastName = "Simic";
        password = "tralalalala123";
        userOperations.insertUser(username, firstName, lastName, password);
        userOperations.declareAdmin(username);
        Assert.assertEquals(1L, userOperations.declareAdmin(username));
 
        general.eraseAll();
 
        username = "rope";
        firstName = "Pero";
        lastName = "Simic";
        password = "tralalalala123";
        userOperations.insertUser(username, firstName, lastName, password);
        Assert.assertEquals(new Integer(0), userOperations.getSentPackages(username));
 
        general.eraseAll();
        
        username = "rope";
        Assert.assertNull(userOperations.getSentPackages(username));
 
        general.eraseAll();
        
        String username1 = "rope";
        String firstName1 = "Pero";
        String lastName1 = "Simic";
        String password1 = "tralalalala123";
        userOperations.insertUser(username1, firstName1, lastName1, password1);
        String username2 = "rope_2";
        String firstName2 = "Pero";
        String lastName2 = "Simic";
        String password2 = "tralalalala321";
        userOperations.insertUser(username2, firstName2, lastName2, password2);
        Assert.assertEquals(2L, userOperations.deleteUsers(username1, username2));
  
        general.eraseAll();
        
        username1 = "rope";
        firstName1 = "Pero";
        lastName1 = "Simic";
        password1 = "tralalalala221";
        userOperations.insertUser(username1, firstName1, lastName1, password1);
        username2 = "rope_2";
        firstName2 = "Pero";
        lastName2 = "Simic";
        password2 = "tralalalala222";
        userOperations.insertUser(username2, firstName2, lastName2, password2);
        Assert.assertEquals(2L, userOperations.getAllUsers().size());
        Assert.assertTrue(userOperations.getAllUsers().contains(username1));
        Assert.assertTrue(userOperations.getAllUsers().contains(username2));
   
	}
	
}
