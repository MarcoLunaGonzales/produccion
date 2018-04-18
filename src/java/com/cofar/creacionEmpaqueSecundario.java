/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;

import com.cofar.util.Util;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import org.apache.commons.dbcp.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ-
 */
public class creacionEmpaqueSecundario {

    private static Logger logger=LogManager.getRootLogger();
    public static double redondeoProduccionSuperior(double numero, int decimales) 
    {
        try{
        BigDecimal decimal=new BigDecimal(String.valueOf(numero));
        return decimal.setScale(decimales,RoundingMode.HALF_UP).doubleValue();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0d;
    }
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
            int codVersion=0;
            double cantidadFin=1000;//cantidad llegar
            double cantidadIni=1000;//cantidad sistema
            double cantidadIncremento=-((cantidadIni-cantidadFin)/cantidadIni);
            Connection con=basicDataSource.getConnection();
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta1="select pp.COD_FORMULA_MAESTRA_ES_VERSION,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_PRESENTACION "+
                        " ,d.COD_DESVIACION,pp.COD_FORMULA_MAESTRA,pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD,pp.COD_FORMULA_MAESTRA_VERSION"+
                        " from PROGRAMA_PRODUCCION pp "+
                        "     inner join desviacion d on d.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION "+
                        "     and d.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD "+
                        "     inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION = "+
                        "     pp.COD_COMPPROD_VERSION and cpv.COD_COMPPROD = pp.COD_COMPPROD "+
                        "     inner join DESVIACION_FORMULA_MAESTRA_DETALLE_ES desf on d.COD_DESVIACION=desf.COD_DESVIACION "+
                        " where d.DESVIACION_PLANIFICADA = 1  "+
                        "      and cpv.COD_TIPO_COMPONENTES_PROD_VERSION=2 "+
                        " group by pp.COD_FORMULA_MAESTRA_VERSION,pp.COD_FORMULA_MAESTRA_ES_VERSION,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_PRESENTACION,d.COD_DESVIACION,pp.COD_FORMULA_MAESTRA,pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD";
            System.out.println("consulta cargar lotes con desvicion "+consulta1);
            ResultSet res=st.executeQuery(consulta1);
            StringBuilder consulta=new StringBuilder("");
            Statement st1=con.createStatement();
            ResultSet res1;
            PreparedStatement pst;
            while(res.next())
            {
               
                consulta1=" DELETE FORMULA_MAESTRA_DETALLE_ES_VERSION  "
                        + " where COD_FORMULA_MAESTRA_ES_VERSION="+res.getInt("COD_FORMULA_MAESTRA_ES_VERSION")+
                        " and COD_TIPO_PROGRAMA_PROD="+res.getInt("COD_TIPO_PROGRAMA_PROD")+
                        " and COD_PRESENTACION_PRODUCTO="+res.getInt("COD_PRESENTACION");
                System.out.println("consulta eliminar formula maestra es version  "+consulta1);
                pst=con.prepareStatement(consulta1);
                if(pst.executeUpdate()>0)System.out.println("se elimino es");
                consulta1="select d.COD_MATERIAL,d.CANTIDAD,d.COD_UNIDAD_MEDIDA "+
                        " from DESVIACION_FORMULA_MAESTRA_DETALLE_ES d "+
                        " where d.COD_DESVIACION= "+res.getInt("COD_DESVIACION")+
                                " and d.COD_PRESENTACION= "+res.getInt("COD_PRESENTACION")+
                                " and d.COD_TIPO_PROGRAMA_PROD="+res.getInt("COD_TIPO_PROGRAMA_PROD");
                Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res2=st2.executeQuery(consulta1);
                while(res2.next())
                {
                    consulta1=" INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO,COD_TIPO_PROGRAMA_PROD, FECHA_MODIFICACION, COD_FORMULA_MAESTRA_ES_VERSION)"+
                            " VALUES ("+res.getInt("COD_FORMULA_MAESTRA_VERSION")+","+
                                res.getInt("COD_FORMULA_MAESTRA")+","+
                                res2.getInt("COD_MATERIAL")+","+
                                res2.getDouble("CANTIDAD")+","+
                                res2.getInt("COD_UNIDAD_MEDIDA")+","+
                                res.getInt("COD_PRESENTACION")+","+
                                res.getInt("COD_TIPO_PROGRAMA_PROD")+
                                ",GETDATE(),"+res.getInt("COD_FORMULA_MAESTRA_ES_VERSION")+")";
                    System.out.println("consulta registra formula maestra es version  "+consulta1);
                    pst=con.prepareStatement(consulta1);
                    if(pst.executeUpdate()>0)System.out.println("se registro es");
                }
                
                consulta1="update FORMULA_MAESTRA_DETALLE_ES_VERSION "+
                         " set CANTIDAD=cpv.TAMANIO_LOTE_PRODUCCION*fmdev.CANTIDAD/pp.CANT_LOTE_PRODUCCION"+
                         " from FORMULA_MAESTRA_DETALLE_ES_VERSION fmdev "
                        +" inner join PROGRAMA_PRODUCCION pp on pp.COD_FORMULA_MAESTRA_ES_VERSION=fmdev.COD_FORMULA_MAESTRA_ES_VERSION"+
                         " and pp.COD_FORMULA_MAESTRA_VERSION=fmdev.COD_VERSION "+
                        " and pp.COD_PRESENTACION=fmdev.COD_PRESENTACION_PRODUCTO "+
                        " and pp.COD_TIPO_PROGRAMA_PROD=fmdev.COD_TIPO_PROGRAMA_PROD "+
                        " inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION"+
                        " and pp.COD_COMPPROD=cpv.COD_COMPPROD "+
                         " where  pp.COD_LOTE_PRODUCCION='"+res.getString("COD_LOTE_PRODUCCION")+"'"+
                            " and pp.COD_PROGRAMA_PROD="+res.getInt("COD_PROGRAMA_PROD")+
                            "  and pp.COD_TIPO_PROGRAMA_PROD="+res.getInt("COD_TIPO_PROGRAMA_PROD")+
                            " and pp.cod_presentacion="+res.getInt("COD_PRESENTACION");
                System.out.println("consulta actualizar totales fmes "+consulta1);
                pst=con.prepareStatement(consulta1);
                if(pst.executeUpdate()>0)System.out.println("se actualizo la formula maestra es ");
                System.out.println("se actualizo mp y ep");
            }
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        
    }

      
    
    
}
