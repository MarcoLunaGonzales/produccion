/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;

import com.cofar.bean.util.correos.EnviarCorreoAprobacionVersionProducto;
import com.cofar.util.Util;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.sql.DataSource;
import org.apache.commons.dbcp.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ-
 */
public class segundo {

    private static Logger logger=LogManager.getRootLogger();
    
    public static void main(String[] args) {
     
        BasicDataSource basicDataSource=new BasicDataSource();
        basicDataSource.setUrl("jdbc:sqlserver://172.16.10.21;databaseName=SARTORIUS");
        basicDataSource.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        basicDataSource.setUsername("sa");
        basicDataSource.setPassword("m0t1t4s@2009");
        basicDataSource.setInitialSize(6);
        basicDataSource.setMaxActive(2000);
        basicDataSource.setMaxWait(60000);
        try
        {
            int codVersion=1303;
            double cantidadFin=16824;//cantidad llegar
            double cantidadIni=16824;//cantidad sistema
            
            Connection con=basicDataSource.getConnection();
            con.setAutoCommit(false);
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select m.NOMBRE_MATERIAL,f.CANTIDAD,f.cod_version,f1.CANTIDAD_LOTE,f1.COD_FORMULA_MAESTRA"
                    + ",c.CANTIDAD_VOLUMEN,c.CANTIDAD_VOLUMEN_DE_DOSIFICADO,c.TOLERANCIA_VOLUMEN_FABRICAR" +
                            " from FORMULA_MAESTRA_DETALLE_MP_VERSION f inner join materiales m on m.COD_MATERIAL=f.COD_MATERIAL" +
                            " inner join FORMULA_MAESTRA_VERSION f1 on f1.COD_VERSION=f.COD_VERSION and f1.COD_FORMULA_MAESTRA=f.COD_FORMULA_MAESTRA"
                    +       " inner join COMPONENTES_PROD_VERSION c on c.COD_VERSION" +
                            " =f1.COD_COMPPROD_VERSION and f1.COD_COMPPROD=c.COD_COMPPROD" +
                            " where f1.COD_COMPPROD_VERSION='"+codVersion+"'"
                    + " order by m.NOMBRE_MATERIAL";
            ResultSet res=st.executeQuery(consulta);
            int codVersionFM=0;
            double cantidadLote=0;
            double cantidadDecrecimiento=0;
            double porcientoReducir=0;
            int codFormulaMestra=0;
            while(res.next())
            {
                codFormulaMestra=res.getInt("COD_FORMULA_MAESTRA");
                cantidadDecrecimiento=(res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO")>0?(res.getDouble("CANTIDAD_VOLUMEN")/res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO")):0d);
                porcientoReducir=(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR")/100d);
                
                codVersionFM=res.getInt("cod_version");
                cantidadLote=res.getDouble("CANTIDAD_LOTE");
                System.out.println("m1 "+res.getString("NOMBRE_MATERIAL")+" cant "+res.getDouble("CANTIDAD"));
            }
            consulta=" update FORMULA_MAESTRA_DETALLE_MP_VERSION set cantidad=ROUND((cantidad+(cantidad*"+porcientoReducir+")),2)" +
                     " where cod_version='"+codVersionFM+"'";
            System.out.println("consulta"+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se ecnau");
            consulta=" update FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION set cantidad=ROUND((cantidad+(cantidad*"+porcientoReducir+")),2)" +
                     " where cod_version='"+codVersionFM+"'";
            System.out.println("consulta fmfraccion "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro");
            consulta="update FORMULA_MAESTRA_DETALLE_MP_VERSION set cantidad_unitaria=" +
                     " ((cantidad/"+cantidadLote+")*"+(cantidadDecrecimiento!=0?cantidadDecrecimiento:1)+")" +
                     " where cod_version='"+codVersionFM+"'";
            System.out.println("consulta update fm uni "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registo");
            consulta="update FORMULA_MAESTRA_DETALLE_MP_VERSION set cantidad_unitaria=" +
                     " (cantidad_unitaria-(cantidad_unitaria*"+porcientoReducir+"))" +
                     " where cod_version='"+codVersionFM+"'";
            System.out.println("consulta update fm uni "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registo");
            consulta="update FORMULA_MAESTRA_DETALLE_MP set cantidad=" +
                     "(select f.CANTIDAD from FORMULA_MAESTRA_DETALLE_MP_VERSION f where f.COD_FORMULA_MAESTRA=FORMULA_MAESTRA_DETALLE_MP.COD_FORMULA_MAESTRA" +
                     " and f.COD_VERSION='"+codVersionFM+"'" +
                     " and f.COD_MATERIAL=FORMULA_MAESTRA_DETALLE_MP.COD_MATERIAL)" +
                     " where cod_Formula_maestra='"+codFormulaMestra+"'";
            System.out.println("consulta update cantidad formula"+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro");
            consulta="update FORMULA_MAESTRA_DETALLE_MP set CANTIDAD_UNITARIA=" +
                     "(select f.CANTIDAD_UNITARIA from FORMULA_MAESTRA_DETALLE_MP_VERSION f where f.COD_FORMULA_MAESTRA=FORMULA_MAESTRA_DETALLE_MP.COD_FORMULA_MAESTRA" +
                     " and f.COD_VERSION='"+codVersionFM+"'" +
                     " and f.COD_MATERIAL=FORMULA_MAESTRA_DETALLE_MP.COD_MATERIAL)" +
                     " where cod_Formula_maestra='"+codFormulaMestra+"'";
            System.out.println("consulta update cantidad formula"+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro");
            consulta="update FORMULA_MAESTRA_DETALLE_MP_FRACCIONES set cantidad=" +
                     "(select f.CANTIDAD from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION f where" +
                     " f.COD_FORMULA_MAESTRA=FORMULA_MAESTRA_DETALLE_MP_FRACCIONES.COD_FORMULA_MAESTRA" +
                     " and f.COD_VERSION='"+codVersionFM+"'" +
                    " and f.COD_MATERIAL=FORMULA_MAESTRA_DETALLE_MP_FRACCIONES.COD_MATERIAL" +
                    " and f.COD_FORMULA_MAESTRA_FRACCIONES=FORMULA_MAESTRA_DETALLE_MP_FRACCIONES.COD_FORMULA_MAESTRA_FRACCIONES)" +
                    " where cod_Formula_maestra='"+codFormulaMestra+"'";
            System.out.println("consu "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro");
            con.commit();
        }
        catch(SQLException ex)
        {
            
            ex.printStackTrace();
        }
        
    }

      
    
    
}
