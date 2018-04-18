/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;

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
public class verificacionFracciones {

    private static Logger logger=LogManager.getRootLogger();
    
    public static void main(String[] args) {
        BasicDataSource basicDataSource=new BasicDataSource();
        basicDataSource.setUrl("jdbc:sqlserver://172.16.10.228;databaseName=SARTORIUS");
        basicDataSource.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        basicDataSource.setUsername("sa");
        basicDataSource.setPassword("m0t1t4s@2009");
        basicDataSource.setInitialSize(6);
        basicDataSource.setMaxActive(2000);
        basicDataSource.setMaxWait(60000);
        try
        {
            int codVersion=1450;
            double cantidadFin=1000;//cantidad llegar
            double cantidadIni=1000;//cantidad sistema
            double cantidadIncremento=-((cantidadIni-cantidadFin)/cantidadIni);
            Connection con=basicDataSource.getConnection();
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="set dateformat ymd;select cpv.cod_version as codPP,cpv.nombre_prod_semiterminado,fmv.CANTIDAD_LOTE,cpv.FECHA_INICIO_VIGENCIA,"+
                            " fmv.COD_VERSION,cpv.CANTIDAD_VOLUMEN,CPV.CANTIDAD_VOLUMEN_DE_DOSIFICADO,CPV.TOLERANCIA_VOLUMEN_FABRICAR" +
                            " from COMPONENTES_PROD_VERSION cpv inner join FORMULA_MAESTRA_VERSION fmv on " +
                            " cpv.COD_VERSION=fmv.COD_COMPPROD_VERSION and cpv.COD_COMPPROD=fmv.COD_COMPPROD" +
                            " where cpv.COD_ESTADO_VERSION=2 and cpv.COD_FORMA=2 and cpv.COD_ESTADO_COMPPROD=1"+//and cpv.FECHA_INICIO_VIGENCIA<'2015/03/08 00:00'" +
                            " order by cpv.nombre_prod_semiterminado,fmv.CANTIDAD_LOTE";
            ResultSet res=st.executeQuery(consulta);
            Double incrementoVolumen=0d;
            Double cantidadTotalUnitaria=0d;
            PreparedStatement pst=null;
            Double cantidadDecrecimiento=0d;
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
            while(res.next())
            {
                cantidadDecrecimiento=(res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO")>0?res.getDouble("CANTIDAD_VOLUMEN")/res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO"):0);
                incrementoVolumen=(res.getDouble("CANTIDAD_LOTE")*res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO")/(res.getDouble("CANTIDAD_VOLUMEN")));
                System.out.println(res.getInt("COD_vERSION")+"--------------------------------"+sdf.format(res.getTimestamp("FECHA_INICIO_VIGENCIA")));
                System.out.println(res.getInt("codPP")+" "+"productop "+res.getString("nombre_prod_semiterminado")+" "+res.getDouble("CANTIDAD_VOLUMEN")+" "+res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO")+" "+res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR") );
                consulta="select fm.NRO_DECIMALES_ALMACEN ,fm.cantidad_unitaria,m.NOMBRE_MATERIAL,fm.CANTIDAD,detalleFraccion.cantidadF AS CANTIDADfRACCION,detalleFraccion.nf" +
                        " from FORMULA_MAESTRA_DETALLE_MP_VERSION fm inner join MATERIALES m on fm.COD_MATERIAL=m.COD_MATERIAL "+
                        " outer apply(select sum(fmd.CANTIDAD) as cantidadF,count(*)as nf from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmd where " +
                        " fmd.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA and fm.COD_VERSION=fmd.COD_VERSION and fm.COD_MATERIAL=fmd.COD_MATERIAL) detalleFraccion" +
                        " where fm.COD_VERSION='"+res.getInt("COD_VERSION")+"'" +
                        " order by m.NOMBRE_MATERIAL";
                Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet resdetalle=stDetalle.executeQuery(consulta);
                while(resdetalle.next())
                {
                    cantidadTotalUnitaria=resdetalle.getDouble("cantidad_unitaria")*incrementoVolumen;
                    cantidadTotalUnitaria+=(cantidadTotalUnitaria*res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR")/100d);
                    int cantidadFracciones=(resdetalle.getInt("NRO_DECIMALES_ALMACEN")>0?resdetalle.getInt("NRO_DECIMALES_ALMACEN"):2);
                    cantidadTotalUnitaria=(Math.round(cantidadTotalUnitaria*Math.pow(10,cantidadFracciones))/Math.pow(10,cantidadFracciones));
                    System.out.println((((resdetalle.getDouble("CANTIDAD")!=cantidadTotalUnitaria)||(resdetalle.getDouble("CANTIDAD")!=resdetalle.getDouble("CANTIDADfRACCION")))?"----":"")+" "+resdetalle.getString("NOMBRE_MATERIAL")+" "+resdetalle.getDouble("CANTIDAD")+" "+resdetalle.getDouble("CANTIDADfRACCION")+" "+cantidadTotalUnitaria+" "+resdetalle.getDouble("nf"));
                   /* if(resdetalle.getDouble("CANTIDAD")!=cantidadTotalUnitaria)
                    {
                            consulta="update FORMULA_MAESTRA_DETALLE_MP_VERSION set cantidad_unitaria=(cantidad/(1+"+(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR")/100d)+"))"+
                                 "where cod_version='"+res.getInt("COD_VERSION")+"'";
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("termino 1");
                            consulta="update FORMULA_MAESTRA_DETALLE_MP_VERSION set cantidad_unitaria=" +
                                     " ((cantidad_unitaria/"+res.getDouble("CANTIDAD_LOTE")+")*"+(cantidadDecrecimiento!=0?cantidadDecrecimiento:1)+")" +
                                     " where cod_version='"+res.getInt("COD_vERSION")+"'";
                            System.out.println("consulta update fm uni "+consulta);
                            pst=con.prepareStatement(consulta);
                            if(pst.executeUpdate()>0)System.out.println("se registo");
                    }*/
                }
               /* codFormulaMestra=res.getInt("COD_FORMULA_MAESTRA");
                cantidadDecrecimiento=(res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO")>0?(res.getDouble("CANTIDAD_VOLUMEN")/res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO")):0d);
                porcientoReducir=(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR")/100d);
                codVersionFM=res.getInt("cod_version");
                cantidadLote=res.getDouble("CANTIDAD_LOTE");
                System.out.println("m1 "+res.getString("NOMBRE_MATERIAL")+" cant "+res.getDouble("CANTIDAD"));
                */
            }
            /*consulta=" update FORMULA_MAESTRA_DETALLE_MP_VERSION set cantidad=ROUND((cantidad+(cantidad*"+cantidadIncremento+")),2)" +
                     " where cod_version='"+codVersionFM+"'";
            System.out.println("consulta"+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se ecnau");
            consulta="update FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION set " +
                     " cantidad=(select f.CANTIDAD from FORMULA_MAESTRA_DETALLE_MP_VERSION f where f.COD_VERSION=FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION.COD_VERSION" +
                     " and f.COD_MATERIAL=FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION.COD_MATERIAL)" +
                     " where cod_version='"+codVersionFM+"'";
                     //" and cod_material<>13216";
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
            if(pst.executeUpdate()>0)System.out.println("se registro");*/
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        
    }

      
    
    
}
