/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.util;

import com.cofar.bean.ProgramaProduccion;
import java.lang.String;
import java.lang.String;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 *
 * @author USER
 */
public class Notificacion {
    
    public String correoNotificacion1(ProgramaProduccion p){
        try {
            
            String correo = " <style>.eliminado{background-color:rgb(240, 230, 140);}" +
                    ".modificado{ background-color:rgb(255, 182, 193);}" +
                    ".nuevo{ background-color:rgb(144, 238, 144); }" +
                    ".tablaDetalle {            border-left: solid #bbbbbb 1px            border-top: solid #bbbbbb 1px;" +
                    "        }       .tablaDetalle thead tr td     {            padding:0.4em;            font-weight:bold;            background-color:#9d5a9e;" +
                    "            color:white;            border-right: solid #cccccc 1px            border-bottom: solid #cccccc 1px;            text-align:center;" +
                    "        }        .tablaDetalle tbody tr td{            padding:0.4em;            border-right: solid #aaaaaa 1px;            border-bottom: solid #aaaaaa 1px;" +
                    "        }</style>";
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat format = (DecimalFormat) nf;
            format.applyPattern("#,###.00");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                //String codCompProd=request.getParameter("codCompProd");
                //String codVersion=request.getParameter("codVersion");
                String estiloModif = "style='background-color:rgb(240, 230, 140)'";
                String estiloElim = "style='background-color:rgb(255, 182, 193)'";
                String estiloAgr = "style='background-color:rgb(144, 238, 144)'";
                String estilo = "";
                String codLoteProduccion = p.getCodLoteProduccion();  // request.getParameter("codLoteProduccion");
                String codProgramaProd = p.getCodProgramaProduccion(); //request.getParameter("codProgramaProd");
                String codCompProd = p.getFormulaMaestra().getComponentesProd().getCodCompprod(); //request.getParameter("codCompProd");
                String codTipoProgramaProd = p.getTiposProgramaProduccion().getCodTipoProgramaProd(); //request.getParameter("codTipoProgramaProd");
                String codFormulaMaestra = p.getFormulaMaestra().getCodFormulaMaestra(); //request.getParameter("codFormulaMaestra");
                String nombreProdSemiterminado = p.getFormulaMaestra().getComponentesProd().getNombreProdSemiterminado(); //request.getParameter("nombreProdSemiterminado");
                String nombreTipoProgramaProd = p.getTiposProgramaProduccion().getNombreTipoProgramaProd(); //request.getParameter("nombreTipoProgramaProd");
String consulta = " select m1.COD_MATERIAL COD_MATERIAL_FM,m1.NOMBRE_MATERIAL NOMBRE_MATERIAL_FM,f.CANTIDAD CANTIDAD_FM,m.COD_MATERIAL COD_MATERIAL_P,m.NOMBRE_MATERIAL NOMBRE_MATERIAL_P,p.CANTIDAD CANTIDAD_P,u.abreviatura abreviaturaFM,um.abreviatura abreviaturaP" +
         " from FORMULA_MAESTRA_DETALLE_MP f " +
         " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and f.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' " +
         " inner join materiales m1 on m1.COD_MATERIAL = f.COD_MATERIAL  " +
         " inner join unidades_medida u on u.cod_unidad_medida = f.cod_unidad_medida " +
         " full outer join" +
         " PROGRAMA_PRODUCCION_DETALLE p on" +
         " fm.COD_COMPPROD = p.COD_COMPPROD" +
         " and f.COD_MATERIAL = p.COD_MATERIAL" +
         " inner join materiales m on m.COD_MATERIAL = p.COD_MATERIAL and m.cod_material not in(select mr.cod_material from formula_maestra_detalle_mr mr where mr.cod_formula_maestra = '"+codFormulaMaestra+"' )" +
         " inner join GRUPOS g on g.COD_GRUPO = m.COD_GRUPO and g.COD_CAPITULO = 2" +
         " inner join unidades_medida um on um.cod_unidad_medida = p.cod_unidad_medida " +
         " where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"'" +
         " and p.COD_TIPO_PROGRAMA_PROD = "+codTipoProgramaProd+"" +
         " and p.COD_COMPPROD = "+codCompProd+"" +
         " and p.COD_PROGRAMA_PROD = "+codProgramaProd+"" +
         " and p.COD_ESTADO_REGISTRO = 1 ";

System.out.println("consulta MP"+consulta);

Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
String comparacionDetalle = "";

correo= "<div align='center'>" +
        " <b>DESVIACION DE FORMULA MAESTRA</b><br/><br/>" +
        " <table class='outputText1 tablaDetalle' cellpadding='0' cellspacing='0'>" +
        " <thead><tr><td colspan='2'><b>DATOS DE PRODUCTO</b></td></tr></thead>" +
        " <tbody></tbody>" +
        " <tbody >" +
        " <tr><td>Producto:</td><td>"+nombreProdSemiterminado+"</td></tr>" +
        " <tr><td>Lote</td><td>"+codLoteProduccion+"</td></tr>" +
        " <tr><td>Tipo de Produccion</td><td>"+nombreTipoProgramaProd+"</td></tr></tbody></table><table><TR>" +
        " <TD><SPAN class=outputText2 style='FONT-WEIGHT: bold'>Eliminado</SPAN></TD><TD class=eliminado style='WIDTH: 3em'></TD>" +
        " <TD><SPAN class=outputText2 style='FONT-WEIGHT: bold'>Modificado</SPAN></TD>" +
        " <TD class=modificado style='WIDTH: 3em'></TD>" +
        " <TD><SPAN class=outputText2 style='FONT-WEIGHT: bold'>Nuevo</SPAN></TD>" +
        " <TD class=nuevo style='WIDTH: 3em'></TD></TR></table><br/><b>MATERIA PRIMA</b>" +
        " <table class='border outputText1 tablaDetalle' cellpadding='0' cellspacing='0'>" +
        " <thead><tr><td><b>MATERIAL</b></td><td>ANTES</td><td>DESPUES</td><td>UNID.</td><td>FRACCIONES <br/> ANTES</td><td>FRACCIONES <br/> DESPUES</td></tr></thead>" +
        " <tbody>";


String nombreMaterialFM  = "";
String nombreMaterialP = "";
String codMaterialFM  = "";
String codMaterialP = "";
String abreviaturaFM = "";
String abreviaturaP = "";
String nombreMaterial = "";
List fracciones = new ArrayList();
    while(rs.next()){
        estilo = "";
    nombreMaterialFM= rs.getString("NOMBRE_MATERIAL_FM")==null?"":rs.getString("NOMBRE_MATERIAL_FM");
    nombreMaterialP = rs.getString("NOMBRE_MATERIAL_P")==null?"":rs.getString("NOMBRE_MATERIAL_P");
    codMaterialFM= rs.getString("COD_MATERIAL_FM")==null?"":rs.getString("COD_MATERIAL_FM");
    codMaterialP = rs.getString("COD_MATERIAL_P")==null?"":rs.getString("COD_MATERIAL_P");
    abreviaturaFM = rs.getString("abreviaturaFM")==null?"":rs.getString("abreviaturaFM");
    abreviaturaP = rs.getString("abreviaturaP")==null?"":rs.getString("abreviaturaP");
    double cantidadFM = rs.getDouble("CANTIDAD_FM");
    double cantidadP = rs.getDouble("CANTIDAD_P");
    nombreMaterial = nombreMaterialFM;
    if(nombreMaterialFM.equals(nombreMaterialP) && cantidadFM!=cantidadP){
        estilo = estiloModif;
    }
    if(nombreMaterialFM.equals("") && cantidadFM!=cantidadP){
        estilo = estiloAgr;
        //nombreMaterialFM = nombreMaterialP;
        abreviaturaFM = abreviaturaP;
        codMaterialFM = codMaterialP;
        nombreMaterial = nombreMaterialP;
    }

        Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        consulta = " select f.COD_MATERIAL COD_MATERIAL_FM,f.CANTIDAD CANTIDAD_FM, p.COD_MATERIAL COD_MATERIA_P,p.CANTIDAD CANTIDAD_P" +
                " from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES f" +
                " full outer join PROGRAMA_PRODUCCION_DETALLE_FRACCIONES p" +
                " on f.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and f.COD_MATERIAL = p.COD_MATERIAL and f.COD_FORMULA_MAESTRA_FRACCIONES = p.COD_FORMULA_MAESTRA_FRACCIONES and p.cod_tipo_material = 1  " +
                " where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"'" +
                " and p.COD_COMPPROD = '"+codCompProd+"'" +
                " and p.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' " +
                " and p.COD_PROGRAMA_PROD =  '"+codProgramaProd+"' " +
                " and p.COD_MATERIAL = '"+codMaterialFM+"'" +
                " and p.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'" +
                " ";
        /*consulta = "select p.COD_MATERIAL COD_MATERIAL_FM,p.CANTIDAD CANTIDAD_FM, p.COD_MATERIAL COD_MATERIA_P" +
                " from PROGRAMA_PRODUCCION_DETALLE_FRACCIONES p" +
                " where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"'" +
                " and p.COD_COMPPROD = '"+codCompProd+"'" +
                " and p.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' " +
                " and p.COD_PROGRAMA_PROD =  '"+codProgramaProd+"' " +
                " and p.COD_MATERIAL = '"+codMaterialFM+"'" +
                " and p.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' ";*/
        System.out.println("consulta " + consulta );
        ResultSet rs1 = st1.executeQuery(consulta);
        rs1.last();
        int filas = rs1.getRow()+1;
        rs1.beforeFirst();
        System.out.println("las filas :::" + filas);

        correo+=
        "<tr><td class='border' rowspan='"+filas+"' >"+nombreMaterial+"</td>"+
            "<td class='border' "+estilo+" rowspan="+filas+">"+format.format(cantidadFM)+"</td>"+
            "<td class='border' "+estilo+" rowspan="+filas+">"+format.format(cantidadP)+"</td>"+
            "<td class='border' rowspan="+filas+">"+abreviaturaFM+"</td>";
        
        while(rs1.next()){
            if( nombreMaterialFM.equals(nombreMaterialP) && rs1.getDouble("cantidad_fm")!=rs1.getDouble("cantidad_p")){
                estilo = estiloModif;
            }
            if( nombreMaterialFM.equals("") && rs1.getDouble("cantidad_fm")!=rs1.getDouble("cantidad_p")){
                estilo = estiloAgr;
            }
            
       correo += "<tr><td "+estilo+">"+format.format(rs1.getDouble("cantidad_fm"))+"</td><td "+estilo+">"+format.format(rs1.getDouble("cantidad_p"))+"</td></tr>";
         }
       correo+="</tr>";
         }
        correo +="</tbody>";
  correo+="</table>" +
          " <br/><div><b>MATERIAL DE EMPAQUE PRIMARIO</b></div><br/>" +
          " <table class='border outputText1 tablaDetalle' cellpadding='0' cellspacing='0'>" +
          " <thead><tr><td><b>MATERIAL</b></td><td>ANTES</td><td>DESPUES</td><td>UNID.</td></tr></thead><tbody>";
        //EMPAQUE PRIMARIO
        consulta = " select m1.COD_MATERIAL COD_MATERIAL_FM," +
                "       m1.NOMBRE_MATERIAL NOMBRE_MATERIAL_FM,f.CANTIDAD CANTIDAD_FM," +
                "       m.COD_MATERIAL COD_MATERIAL_P," +
                "       m.NOMBRE_MATERIAL NOMBRE_MATERIAL_P," +
                "       p.CANTIDAD CANTIDAD_P," +
                "       u.abreviatura abreviaturaFM," +
                "       um.abreviatura abreviaturaP" +
                "     from FORMULA_MAESTRA_DETALLE_EP f" +
                "     inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA =" +
                "     f.COD_FORMULA_MAESTRA and f.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'" +
                "     inner join materiales m1 on m1.COD_MATERIAL = f.COD_MATERIAL" +
                "     inner join unidades_medida u on u.cod_unidad_medida = f.cod_unidad_medida" +
                "     inner join PRESENTACIONES_PRIMARIAS prp on prp.COD_PRESENTACION_PRIMARIA = f.COD_PRESENTACION_PRIMARIA and prp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"'" +
                "     and prp.COD_COMPPROD = fm.COD_COMPPROD" +
                "     full outer join PROGRAMA_PRODUCCION_DETALLE p on fm.COD_COMPPROD =" +
                "     p.COD_COMPPROD and f.COD_MATERIAL = p.COD_MATERIAL" +
                "     inner join materiales m on m.COD_MATERIAL = p.COD_MATERIAL" +
                "     inner join GRUPOS g on g.COD_GRUPO = m.COD_GRUPO and g.COD_CAPITULO = 3" +
                "     inner join unidades_medida um on um.cod_unidad_medida = p.cod_unidad_medida" +
                "     where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and" +
                "      p.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' and " +
                "      p.COD_COMPPROD = '"+codCompProd+"' and" +
                "      p.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and" +
                "      p.COD_ESTADO_REGISTRO = 1 ";
        System.out.println("consulta EP " + consulta);

        Statement st1 = con.createStatement();
        ResultSet rs1 = st1.executeQuery(consulta);
        nombreMaterialFM= "";
            nombreMaterialP = "";
            codMaterialFM= "";
            codMaterialP = "";
            abreviaturaFM = "";
            abreviaturaP = "";
            //double cantidadFM = 0.0;
            //double cantidadP = 0.0;
        while(rs1.next()){
            nombreMaterialFM= rs1.getString("NOMBRE_MATERIAL_FM")==null?"":rs1.getString("NOMBRE_MATERIAL_FM");
            nombreMaterialP = rs1.getString("NOMBRE_MATERIAL_P")==null?"":rs1.getString("NOMBRE_MATERIAL_P");
            codMaterialFM= rs1.getString("COD_MATERIAL_FM")==null?"":rs1.getString("COD_MATERIAL_FM");
            codMaterialP = rs1.getString("COD_MATERIAL_P")==null?"":rs1.getString("COD_MATERIAL_P");
            abreviaturaFM = rs1.getString("abreviaturaFM")==null?"":rs1.getString("abreviaturaFM");
            abreviaturaP = rs1.getString("abreviaturaP")==null?"":rs1.getString("abreviaturaP");
            double cantidadFM = rs1.getDouble("CANTIDAD_FM");
            double cantidadP = rs1.getDouble("CANTIDAD_P");
            nombreMaterial = nombreMaterialFM;
            estilo = "";

            if(nombreMaterialFM.equals(nombreMaterialP) && cantidadFM!=cantidadP){
                estilo = estiloModif;
            }
            if(nombreMaterialFM.equals("") && cantidadFM!=cantidadP){
                estilo = estiloAgr;
                //nombreMaterialFM = nombreMaterialP;
                abreviaturaFM = abreviaturaP;
                codMaterialFM = codMaterialP;
                nombreMaterial = nombreMaterialP;
            }
           correo+= "<tr><td class='border' >"+nombreMaterial+"</td>"+
            "<td class='border' "+estilo+">"+format.format(cantidadFM)+"</td>"+
            "<td class='border' "+estilo+">"+format.format(cantidadP)+"</td>"+
            "<td class='border'>"+abreviaturaFM+"</td>"+
            "</tr>";
                    
        }
    correo +="</tbody></table><br/><div><b>MATERIAL DE EMPAQUE SECUNDARIO</b></div><br/>" +
            " <table class='border outputText1 tablaDetalle' cellpadding='0' cellspacing='0'>" +
            " <thead><tr><td><b>MATERIAL</b></td><td>ANTES</td><td>DESPUES</td><td>UNID.</td></tr></thead><tbody>";
        //EMPAQUE SECUNDARIO

        consulta =" select m1.COD_MATERIAL COD_MATERIAL_FM," +
                "       m1.NOMBRE_MATERIAL NOMBRE_MATERIAL_FM," +
                "       f.CANTIDAD CANTIDAD_FM," +
                "       m.COD_MATERIAL COD_MATERIAL_P," +
                "       m.NOMBRE_MATERIAL NOMBRE_MATERIAL_P," +
                "       p.CANTIDAD CANTIDAD_P," +
                "       u.abreviatura abreviaturaFM," +
                "       um.abreviatura abreviaturaP" +
                "     from FORMULA_MAESTRA_DETALLE_ES f" +
                "     inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA and f.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'" +
                "     inner join materiales m1 on m1.COD_MATERIAL = f.COD_MATERIAL" +
                "     inner join unidades_medida u on u.cod_unidad_medida = f.cod_unidad_medida" +
                "     inner join COMPONENTES_PRESPROD cprp on cprp.COD_PRESENTACION = f.COD_PRESENTACION_PRODUCTO and cprp.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"'" +
                "     and cprp.COD_COMPPROD = fm.COD_COMPPROD and f.COD_TIPO_PROGRAMA_PROD = cprp.COD_TIPO_PROGRAMA_PROD" +
                "     full outer join PROGRAMA_PRODUCCION_DETALLE p on fm.COD_COMPPROD =" +
                "     p.COD_COMPPROD and f.COD_MATERIAL = p.COD_MATERIAL" +
                "     inner join materiales m on m.COD_MATERIAL = p.COD_MATERIAL" +
                "     inner join GRUPOS g on g.COD_GRUPO = m.COD_GRUPO and g.COD_CAPITULO = 4" +
                "     inner join unidades_medida um on um.cod_unidad_medida = p.cod_unidad_medida" +
                "     where p.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and" +
                "      p.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"' and " +
                "      p.COD_COMPPROD = '"+codCompProd+"' and" +
                "      p.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and" +
                "      p.COD_ESTADO_REGISTRO = 1 ";
        System.out.println("consulta ES " + consulta);

        Statement st2 = con.createStatement();
        ResultSet rs2 = st2.executeQuery(consulta);
        nombreMaterialFM= "";
            nombreMaterialP = "";
            codMaterialFM= "";
            codMaterialP = "";
            abreviaturaFM = "";
            abreviaturaP = "";
            //double cantidadFM = 0.0;
            //double cantidadP = 0.0;
        while(rs2.next()){
            nombreMaterialFM= rs2.getString("NOMBRE_MATERIAL_FM")==null?"":rs2.getString("NOMBRE_MATERIAL_FM");
            nombreMaterialP = rs2.getString("NOMBRE_MATERIAL_P")==null?"":rs2.getString("NOMBRE_MATERIAL_P");
            codMaterialFM= rs2.getString("COD_MATERIAL_FM")==null?"":rs2.getString("COD_MATERIAL_FM");
            codMaterialP = rs2.getString("COD_MATERIAL_P")==null?"":rs2.getString("COD_MATERIAL_P");
            abreviaturaFM = rs2.getString("abreviaturaFM")==null?"":rs2.getString("abreviaturaFM");
            abreviaturaP = rs2.getString("abreviaturaP")==null?"":rs2.getString("abreviaturaP");
            double cantidadFM = rs2.getDouble("CANTIDAD_FM");
            double cantidadP = rs2.getDouble("CANTIDAD_P");
            nombreMaterial = nombreMaterialFM;
            estilo = "";

            if(nombreMaterialFM.equals(nombreMaterialP) && cantidadFM!=cantidadP){
                estilo = estiloModif;
            }
            if(nombreMaterialFM.equals("") && cantidadFM!=cantidadP){
                estilo = estiloAgr;
                //nombreMaterialFM = nombreMaterialP;
                abreviaturaFM = abreviaturaP;
                codMaterialFM = codMaterialP;
                nombreMaterial = nombreMaterialP;
            }
           correo +=" <tr><td class='border' >"+nombreMaterial+"</td>" +
                   " <td class='border' "+estilo+">"+format.format(cantidadFM)+"</td>" +
                   " <td class='border' "+estilo+">"+format.format(cantidadP)+"</td>" +
                   " <td class='border' >"+abreviaturaFM+"</td></tr>";
            
        }

        
    correo+="</tbody></table></div> ";

        } catch (Exception e) {
        }
        return null;
    }

}
