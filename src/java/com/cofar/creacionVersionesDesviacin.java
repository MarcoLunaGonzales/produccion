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
public class creacionVersionesDesviacin {

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
        basicDataSource.setUrl("jdbc:sqlserver://172.16.10.228s;databaseName=SARTORIUS");
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
            String consulta1="select pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD,pp.COD_COMPPROD,pp.COD_COMPPROD_VERSION, "+
                            " pp.COD_FORMULA_MAESTRA_ES_VERSION,SUM(pp.CANT_LOTE_PRODUCCION) as cantidadLoteProduccion,D.COD_DESVIACION, "+
                            " (select sum(pp.CANT_LOTE_PRODUCCION) from programa_produccion p1 where p1.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION and p1.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD group by p1.COD_LOTE_PRODUCCION) as cantidadTotalLote"+
                            " ,cpv.TOLERANCIA_VOLUMEN_FABRICAR,cpv.CANTIDAD_VOLUMEN,cpv.CANTIDAD_VOLUMEN_DE_DOSIFICADO,cpv.COD_AREA_EMPRESA"+
                            " from PROGRAMA_PRODUCCION pp "+
                            "	inner join desviacion d on d.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION "+
                            "    and d.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD "+
                            " inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION and cpv.COD_COMPPROD=pp.COD_COMPPROD"+
                            " where d.DESVIACION_PLANIFICADA=1 "+
                            "  and pp.COD_LOTE_PRODUCCION<>'704066'"+
                            " and pp.COD_LOTE_PRODUCCION <>'108104-R'"+
                            " group by pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD,pp.COD_COMPPROD,pp.COD_COMPPROD_VERSION, "+
                            " pp.COD_FORMULA_MAESTRA_ES_VERSION,cpv.COD_AREA_EMPRESA,D.COD_DESVIACION ,cpv.TOLERANCIA_VOLUMEN_FABRICAR,cpv.CANTIDAD_VOLUMEN,cpv.CANTIDAD_VOLUMEN_DE_DOSIFICADO"+
                            " order by pp.COD_LOTE_PRODUCCION desc";
            System.out.println("consulta cargar lotes con desvicion "+consulta1);
            ResultSet res=st.executeQuery(consulta1);
            StringBuilder consulta=new StringBuilder("");
            Statement st1=con.createStatement();
            ResultSet res1;
            PreparedStatement pst;
            while(res.next())
            {
                System.out.println("--------------------------------------------"+res.getString("COD_LOTE_PRODUCCION")+"---------------------------------------------");
               consulta=new StringBuilder("EXEC PAA_GENERACION_NUEVA_VERSION_PRODUCTO ");
                                        consulta.append(res.getInt("COD_COMPPROD")).append(",");
                                        consulta.append("2,");//modificacion por desviacion
                                        consulta.append(0).append(",");
                                        consulta.append(0).append(",");
                                        consulta.append("?,");
                                        consulta.append(res.getInt("COD_COMPPROD_VERSION")).append(",");
                                        consulta.append(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                System.out.println("consulta generar version desviacion "+consulta.toString());
                CallableStatement callCreateVersion=con.prepareCall(consulta.toString());
                callCreateVersion.registerOutParameter(1,java.sql.Types.INTEGER);
                callCreateVersion.execute();
                int codVersionGenerada=callCreateVersion.getInt(1);
                int codFormulaMaestra=0;
                int codVersionFmGenerada=0;
                consulta=new StringBuilder(" update PROGRAMA_PRODUCCION set COD_COMPPROD_VERSION=cpv.COD_VERSION");
                            consulta.append(" ,COD_FORMULA_MAESTRA_VERSION=fmv.COD_VERSION");
                            consulta.append(" ,COD_FORMULA_MAESTRA_ES_VERSION=fmes.COD_FORMULA_MAESTRA_ES_VERSION");
                    consulta.append(" FROM PROGRAMA_PRODUCCION pp");
                            consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD");
                            consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                    consulta.append(" and cpv.COD_VERSION=fmv.COD_COMPPROD_VERSION");
                            consulta.append(" inner join FORMULA_MAESTRA_ES_VERSION fmes on fmes.COD_VERSION=cpv.COD_VERSION");
                    consulta.append(" where pp.COD_LOTE_PRODUCCION='").append(res.getString("COD_LOTE_PRODUCCION")).append("'");
                            consulta.append(" and pp.COD_COMPPROD=").append(res.getInt("COD_COMPPROD"));
                            consulta.append(" and pp.COD_PROGRAMA_PROD=").append(res.getInt("COD_PROGRAMA_PROD"));
                            consulta.append(" and cpv.COD_VERSION=").append(codVersionGenerada);
                    System.out.println("consulta registrar programa produccion desviacion "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)System.out.println("se registro el cambio");
                
                
                
                consulta1="select f.COD_FORMULA_MAESTRA,f.COD_VERSION "+
                            "from FORMULA_MAESTRA_VERSION f where f.COD_COMPPROD_VERSION= "+codVersionGenerada+
                            "and f.COD_COMPPROD="+res.getInt("COD_COMPPROD");
                res1=st1.executeQuery(consulta1);
                if(res1.next())
                {
                    codFormulaMaestra=res1.getInt("COD_FORMULA_MAESTRA");
                    codVersionFmGenerada=res1.getInt("COD_VERSION");
                }
                consulta1="delete FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION where COD_FORMULA_MAESTRA="+codFormulaMaestra+" and COD_VERSION="+codVersionFmGenerada;
                System.out.println("consulta eliminar mp fraccion "+consulta1);
                pst=con.prepareStatement(consulta1);
                if(pst.executeUpdate()>0)System.out.println("se registraron mp fraccion");
                consulta1="delete FORMULA_MAESTRA_DETALLE_MP_VERSION  WHERE COD_FORMULA_MAESTRA="+codFormulaMaestra+" and COD_VERSION="+codVersionFmGenerada;
                System.out.println("consulta eliminar mp "+consulta1);
                pst=con.prepareStatement(consulta1);
                if(pst.executeUpdate()>0)System.out.println("se elimino mp");
                consulta1="select df.COD_MATERIAL,dfm.CANTIDAD as cantidadFraccion,isnull(dfm.COD_TIPO_MATERIAL_PRODUCCION,0)+1 as COD_TIPO_MATERIAL_PRODUCCION, "+
                            "	dfm.COD_PROD ,e.VALOR_EQUIVALENCIA as equivalenciaMg" +
                            "       ,e2.VALOR_EQUIVALENCIA as equivalenciaMl,df.COD_UNIDAD_MEDIDA,m.DENSIDAD,um.COD_TIPO_MEDIDA"+
                            " ,(select sum(d1.CANTIDAD) from DESVIACION_FORMULA_MAESTRA_DETALLE_MP_FRACCIONES d1 where d1.COD_DESVIACION=df.COD_DESVIACION"+
                            " and d1.COD_MATERIAL=df.COD_MATERIAL and isnull(dfm.COD_TIPO_MATERIAL_PRODUCCION,0)=isnull(d1.COD_TIPO_MATERIAL_PRODUCCION,0)) as CANTIDAD"+
                            " from DESVIACION_FORMULA_MAESTRA_DETALLE_MP df "+
                            "	inner join DESVIACION_FORMULA_MAESTRA_DETALLE_MP_FRACCIONES dfm "+
                            "     on df.COD_DESVIACION=dfm.COD_DESVIACION "+
                            "     and df.COD_MATERIAL=dfm.COD_MATERIAL "+
                            " and isnull(dfm.COD_PROD,0)=0"+
                            " left outer join EQUIVALENCIAS e on e.COD_UNIDAD_MEDIDA=df.COD_UNIDAD_MEDIDA "+
                            "              and e.COD_UNIDAD_MEDIDA2=7 "+
                            "              and e.COD_ESTADO_REGISTRO=1 "+
                            "      left outer join EQUIVALENCIAS e2 on e2.COD_UNIDAD_MEDIDA=df.COD_UNIDAD_MEDIDA "+
                            "              and e2.COD_UNIDAD_MEDIDA2=2 "+
                            "              and e2.COD_ESTADO_REGISTRO=1"+
                            " left outer join MATERIALES_DENSIDAD_CONVERSION_GRAMOS m on m.COD_MATERIAL=df.COD_MATERIAL"+
                            " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=df.COD_UNIDAD_MEDIDA"+
                            " where df.COD_DESVIACION="+res.getInt("COD_DESVIACION");
                System.out.println("consulta materiales "+consulta1);
                res1=st1.executeQuery(consulta1);
                int codMaterial=0;
                int codTipoMaterial=0;
                int codFormulaMaestraFracciones=0;
                int codFormulaMaestraMpVersion=0;
                while(res1.next())
                {
                    if(codMaterial!=res1.getInt("COD_MATERIAL")||codTipoMaterial!=res1.getInt("COD_TIPO_MATERIAL_PRODUCCION"))
                    {
                        double cantidadMaterial=res1.getDouble("CANTIDAD")*res.getDouble("cantidadLoteProduccion")/res.getDouble("cantidadTotalLote");
                        double cantidadTotalGramos=cantidadMaterial*(res1.getInt("COD_TIPO_MEDIDA")==2?res1.getDouble("equivalenciaMg"):(res1.getDouble("equivalenciaMl")*res1.getDouble("DENSIDAD")));
                        double cantidadTotalGramosAux=cantidadTotalGramos/(1+res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR")/100);
                        if(res.getInt("COD_AREA_EMPRESA")==81)
                        {
                            cantidadTotalGramosAux=cantidadTotalGramosAux/(res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO")/res.getDouble("CANTIDAD_VOLUMEN"));
                        }
                        
                        double cantidadUnitaria=redondeoProduccionSuperior(cantidadTotalGramosAux/res.getDouble("cantidadLoteProduccion"),6);
                        consulta1="INSERT INTO FORMULA_MAESTRA_DETALLE_MP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, NRO_PREPARACIONES,CANTIDAD_UNITARIA_GRAMOS, CANTIDAD_TOTAL_GRAMOS,CANTIDAD_MAXIMA_MATERIAL_POR_FRACCION, DENSIDAD_MATERIAL,COD_TIPO_MATERIAL_PRODUCCION)"+
                                 " VALUES ("+codVersionFmGenerada+","+codFormulaMaestra+","+res1.getInt("COD_MATERIAL")+","+cantidadMaterial+","+res1.getInt("COD_UNIDAD_MEDIDA")+",1,"+cantidadUnitaria+","+cantidadTotalGramos+",0,"+res1.getDouble("DENSIDAD")+","+res1.getInt("COD_TIPO_MATERIAL_PRODUCCION")+")";
                        System.out.println("consulta registrar fm version "+consulta1);
                        pst=con.prepareStatement(consulta1,PreparedStatement.RETURN_GENERATED_KEYS);
                        if(pst.executeUpdate()>0)System.out.println("se registro mp");
                        ResultSet res2=pst.getGeneratedKeys();
                        res2.next();
                        codFormulaMaestraMpVersion=res2.getInt(1);
                        codMaterial=res1.getInt("COD_MATERIAL");
                        codTipoMaterial=res1.getInt("COD_TIPO_MATERIAL_PRODUCCION");
                        codFormulaMaestraFracciones=0;
                    }
                    consulta1=" INSERT INTO FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION(COD_VERSION,COD_FORMULA_MAESTRA, COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES, CANTIDAD, PORCIENTO_FRACCION,COD_TIPO_MATERIAL_PRODUCCION,COD_FORMULA_MAESTRA_DETALLE_MP_VERSION)"+
                               " VALUES ("+codVersionFmGenerada+","+codFormulaMaestra+","+res1.getInt("COD_MATERIAL")+","+codFormulaMaestraFracciones+",0,"+(res1.getDouble("cantidadFraccion")/res1.getDouble("CANTIDAD")*100)+","+res1.getDouble("COD_TIPO_MATERIAL_PRODUCCION")+","+codFormulaMaestraMpVersion+")";
                    System.out.println("consulta registrar fraccion  "+consulta1);
                    pst=con.prepareStatement(consulta1);
                    if(pst.executeUpdate()>0)System.out.println("se registro la fraccion");
                    codFormulaMaestraFracciones++;
                }
                consulta1="select pp.COD_TIPO_PROGRAMA_PROD,pp.COD_PRESENTACION,ppv.COD_ENVASEPRIM,(pp.CANT_LOTE_PRODUCCION/ppv.CANTIDAD) as cantidadPresentacionesprimarias "+
                            " from PROGRAMA_PRODUCCION pp "+
                                    " inner join PRESENTACIONES_PRIMARIAS_VERSION ppv on ppv.COD_COMPPROD=pp.COD_COMPPROD "+
                                            " and ppv.COD_VERSION=pp.COD_COMPPROD_VERSION "+
                                            " and ppv.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD "+
                            " where pp.COD_LOTE_PRODUCCION= '"+res.getInt("COD_LOTE_PRODUCCION")+"'"+
                                    " and pp.COD_PROGRAMA_PROD= "+res.getInt("COD_PROGRAMA_PROD")+
                                    " and pp.COD_COMPPROD="+res.getInt("COD_COMPPROD");
                System.out.println("consulta cargar presentaciones primarias "+consulta1);
                res1=st1.executeQuery(consulta1);
                while(res1.next())
                {
                    consulta1="select ppv.COD_PRESENTACION_PRIMARIA "
                            + " from PRESENTACIONES_PRIMARIAS_VERSION ppv "
                            + " where ppv.COD_VERSION= "+codVersionGenerada
                            + " and ppv.COD_ENVASEPRIM= "+res1.getInt("COD_ENVASEPRIM")
                            + " and ppv.COD_TIPO_PROGRAMA_PROD="+res1.getInt("COD_TIPO_PROGRAMA_PROD");
                    Statement st2=con.createStatement();
                    ResultSet res2=st2.executeQuery(consulta1);
                    int codPresentacionPrimariaGenerada=0;
                    if(res2.next())codPresentacionPrimariaGenerada=res2.getInt("COD_PRESENTACION_PRIMARIA");
                    consulta1="delete FORMULA_MAESTRA_DETALLE_EP_VERSION "+
                                "where COD_PRESENTACION_PRIMARIA = "+codPresentacionPrimariaGenerada+" and "+
                                "      COD_VERSION = "+codVersionGenerada+" and "+
                                "      COD_FORMULA_MAESTRA = "+codFormulaMaestra;
                    System.out.println("consulta eliminar fm ep "+consulta1);
                    pst=con.prepareStatement(consulta1);
                    if(pst.executeUpdate()>0)System.out.println("se elimino el envase primario");
                    consulta1="select df.COD_MATERIAL,df.CANTIDAD,df.COD_UNIDAD_MEDIDA "+
                                " from PROGRAMA_PRODUCCION pp "+
                                "	inner join PRESENTACIONES_PRIMARIAS_VERSION ppv on ppv.COD_COMPPROD=pp.COD_COMPPROD "+
                                "    		and ppv.COD_VERSION=pp.COD_COMPPROD_VERSION "+
                                "            and ppv.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD "+
                                "    inner join DESVIACION_FORMULA_MAESTRA_DETALLE_EP df on df.COD_PRESENTACION_PRIMARIA=ppv.COD_PRESENTACION_PRIMARIA "+
                                "    		and df.COD_DESVIACION= "+res.getInt("COD_DESVIACION")+
                                " where pp.COD_LOTE_PRODUCCION= '"+res.getString("COD_LOTE_PRODUCCION")+"'"+
                                "    and pp.COD_PROGRAMA_PROD= "+res.getInt("COD_PROGRAMA_PROD")+
                                "    and pp.COD_COMPPROD= "+res.getInt("COD_COMPPROD")+
                                "    and pp.COD_TIPO_PROGRAMA_PROD="+res1.getInt("COD_TIPO_PROGRAMA_PROD");
                    System.out.println("consulta materiales ep "+consulta1);
                    res2=st2.executeQuery(consulta1);
                    while(res2.next())
                    {
                        consulta1="INSERT INTO FORMULA_MAESTRA_DETALLE_EP_VERSION(COD_VERSION, COD_FORMULA_MAESTRA, COD_PRESENTACION_PRIMARIA, COD_MATERIAL,CANTIDAD_UNITARIA,CANTIDAD, COD_UNIDAD_MEDIDA)"+
                                    " VALUES ("+codVersionFmGenerada+","+codFormulaMaestra+","+codPresentacionPrimariaGenerada+","+res2.getInt("COD_MATERIAL")+","+(res2.getDouble("CANTIDAD")/res1.getDouble("cantidadPresentacionesprimarias"))+","+res2.getDouble("CANTIDAD")+","+res2.getDouble("COD_UNIDAD_MEDIDA")+")";
                        System.out.println("consulta registrar fm ep "+consulta1);
                        pst=con.prepareStatement(consulta1);
                        if(pst.executeUpdate()>0)System.out.println("se registro el emapqie primario");
                    }
                    consulta1="  select f.COD_FORMULA_MAESTRA_ES_VERSION"+
                             " from FORMULA_MAESTRA_ES_VERSION f where f.COD_VERSION="+codVersion;
                    System.out.println("consulta buscar es version "+consulta1);
                    res2=st2.executeQuery(consulta1);
                    int codFormulaMaestraEsVersion=0;
                    if(res2.next())codFormulaMaestraEsVersion=res.getInt("COD_FORMULA_MAESTRA_ES_VERSION");
                    consulta1=" DELETE FORMULA_MAESTRA_DETALLE_ES_VERSION  "
                            + " where COD_FORMULA_MAESTRA_ES_VERSION="+codFormulaMaestraEsVersion+
                            " and COD_TIPO_PROGRAMA_PROD="+res1.getInt("COD_TIPO_PROGRAMA_PROD")+
                            " and COD_PRESENTACION_PRODUCTO="+res1.getInt("COD_PRESENTACION");
                    System.out.println("consulta eliminar formula maestra es version  "+consulta1);
                    pst=con.prepareStatement(consulta1);
                    if(pst.executeUpdate()>0)System.out.println("se elimino es");
                    consulta1="select d.COD_MATERIAL,d.CANTIDAD,d.COD_UNIDAD_MEDIDA "+
                            " from DESVIACION_FORMULA_MAESTRA_DETALLE_ES d "+
                            " where d.COD_DESVIACION= "+res.getInt("COD_DESVIACION")+
                                    " and d.COD_PRESENTACION= "+res1.getInt("COD_PRESENTACION")+
                                    " and d.COD_TIPO_PROGRAMA_PROD="+res1.getInt("COD_TIPO_PROGRAMA_PROD");
                    res2=st2.executeQuery(consulta1);
                    while(res2.next())
                    {
                        consulta1=" INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION, COD_FORMULA_MAESTRA,COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA, COD_PRESENTACION_PRODUCTO,COD_TIPO_PROGRAMA_PROD, FECHA_MODIFICACION, COD_FORMULA_MAESTRA_ES_VERSION)"+
                                " VALUES ("+codVersionFmGenerada+","+codFormulaMaestra+","+res2.getInt("COD_MATERIAL")+","+res2.getDouble("CANTIDAD")+","+res2.getInt("COD_UNIDAD_MEDIDA")+","+res1.getInt("COD_PRESENTACION")+","+res1.getInt("COD_TIPO_PROGRAMA_PROD")+",GETDATE(),"+codFormulaMaestraEsVersion+")";
                        System.out.println("consulta registra formula maestra es version  "+consulta1);
                        pst=con.prepareStatement(consulta1);
                        if(pst.executeUpdate()>0)System.out.println("se registro es");
                    }
                }
                consulta1="update FORMULA_MAESTRA_DETALLE_ES_VERSION "+
                         " set CANTIDAD=cpv.TAMANIO_LOTE_PRODUCCION/pp.CANT_LOTE_PRODUCCION*fmdev.CANTIDAD"+
                         " from FORMULA_MAESTRA_DETALLE_ES_VERSION fmdev inner join PROGRAMA_PRODUCCION pp on pp.COD_FORMULA_MAESTRA_ES_VERSION=fmdev.COD_FORMULA_MAESTRA_ES_VERSION and pp.COD_FORMULA_MAESTRA_VERSION=fmdev.COD_VERSION and pp.COD_PRESENTACION=fmdev.COD_PRESENTACION_PRODUCTO and pp.COD_TIPO_PROGRAMA_PROD=fmdev.COD_TIPO_PROGRAMA_PROD inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION and pp.COD_COMPPROD=cpv.COD_COMPPROD "+
                         " where  pp.COD_LOTE_PRODUCCION='"+res.getString("COD_LOTE_PRODUCCION")+"'"+
                            " and pp.COD_PROGRAMA_PROD="+res.getInt("COD_PROGRAMA_PROD");
                System.out.println("consulta actualizar totales fmes "+consulta1);
                pst=con.prepareCall(consulta1);
                if(pst.executeUpdate()>0)System.out.println("se actualizo la formula maestra es ");
                consulta1="exec PAA_ACTUALIZACION_CANTIDADES_FORMULA_MAESTRA_VERSION "+codVersionGenerada;
                System.out.println("consulta actualizar cantidad mp y ep "+consulta1);
                pst=con.prepareStatement(consulta1);
                pst.executeUpdate();
                System.out.println("se actualizo mp y ep");
            }
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        
    }

      
    
    
}
