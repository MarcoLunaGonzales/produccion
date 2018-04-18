/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.util;


import com.cofar.bean.DocumentacionRespuestas;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

/**
 *
 * @author hvaldivia
 */
public class Transactions_1 {
    public  String  cargarDatosDeposito(Connection con,InputStream s,String codEntidadFinanciera,String fechaIngresoDeposito,String codDocumento)  {
            String respuesta = "";
        try {
            Workbook work=Workbook.getWorkbook(s);
            //Workbook work=Workbook.getWorkbook(new File("c:\\xls\\a.xls"));
            Sheet hoja=work.getSheet(0);
            //System.out.println("el codigo entidad financiera" + codEntidadFinanciera);
            
            this.llenaDatosFormato(hoja, con, codEntidadFinanciera,fechaIngresoDeposito,codDocumento);
            respuesta = "datos cargados correctamente";
        }
        catch(Exception e){
            e.printStackTrace();
        }
            return respuesta;

    }
public void llenaDatosFormato(Sheet hoja,Connection con,String codEntidadFinanciera,String fechaIngresoDeposito,String codDocumento){
        try {

            int filas=hoja.getRows();
            double costoActualizado=0.0d;
            double costoActualizadoFinal=0.0d;
            String  fechaActualizacion="";
            String  codSalidaVenta="";
            String  codPresentacion="";

            String fechaDeposito = "";
            String agenciaDeposito = "";
            String descripcionDeposito = "";
            String referenciaDeposito = "";
            Double itfDeposito = 0.0;
            Double debitoDeposito = 0.0;
            Double creditoDeposito = 0.0;
            Double saldoDeposito = 0.0;
            String agencia ="";
            String tipoDeposito="";

            int posicionFecha = -1;
            int posicionAgencia = -1;
            int posicionTipoDeposito =-1;
            int posicionReferencia =-1;
            int posicionItf =-1;
            int posicionDebito =-1;
            int posicionCredito =-1;
            int posicionSaldo =-1;
            int posicionDescripcion=-1;
            
            Statement  st=con.createStatement();

            //registro de datos de cabecera
            //registro de ingresos_deposito
            SimpleDateFormat sf = new SimpleDateFormat("yyyy/MM/dd");
            String fechaRegistro = sf.format(new Date());

            String consulta = "select (isnull(max(COD_INGRESO_DEPOSITO),0)+1) COD_INGRESO_DEPOSITO  from INGRESOS_DEPOSITO ";
            System.out.println("consulta" + consulta);
            Statement stCodigoIngresoDeposito = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsCodigoIngresoDeposito = stCodigoIngresoDeposito.executeQuery(consulta);
            String codIngresoDeposito="";
            if(rsCodigoIngresoDeposito.next()){
                codIngresoDeposito = rsCodigoIngresoDeposito.getString("COD_INGRESO_DEPOSITO");
            }


//            consulta = "INSERT INTO  INGRESOS_DEPOSITO (COD_INGRESO_DEPOSITO,  COD_ENTIDAD_FINANCIERA, " +
//                    "  FECHA_REGISTRO,   COD_ESTADO_DEPOSITO ) VALUES ( "+codIngresoDeposito+" ," +
//                    "  "+codEntidadFinanciera+", '"+fechaRegistro+"', 1);" ;
//            System.out.println("consulta" + consulta);
//            Statement stIngresoDeposito = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//            stIngresoDeposito.executeUpdate(consulta);

            String codPreg="";
            for(int i=2;i<filas;i++){

                
                Cell celdaFechaDeposito=hoja.getCell(0,i);
                String descripcionPregunta=celdaFechaDeposito.getContents();
                System.out.println("dfato 1 "+descripcionPregunta);
                
                celdaFechaDeposito=hoja.getCell(1,i);
                String codTipoPregunta=celdaFechaDeposito.getContents();
                System.out.println("dato 12 "+codTipoPregunta);

                celdaFechaDeposito=hoja.getCell(2,i);
                String preguntaCerrada=celdaFechaDeposito.getContents();
                System.out.println("dato 12 "+preguntaCerrada);

                celdaFechaDeposito=hoja.getCell(3,i);
                String descripcionRespueta=celdaFechaDeposito.getContents();
                System.out.println("dato 12 "+descripcionRespueta);

                celdaFechaDeposito=hoja.getCell(4,i);
                String esRespuesta=celdaFechaDeposito.getContents();
                System.out.println("dato 12 "+esRespuesta);
                


                
                if(!descripcionPregunta.equals("")){
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                consulta="select isnull(max(dp.COD_PREGUNTA),0)+1 as codPregunta from DOCUMENTACION_PREGUNTAS dp where dp.COD_DOCUMENTO='"+codDocumento+"'";
                    System.out.println("consulta" + consulta);
                
                Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st1.executeQuery(consulta);
                
                if(res.next())codPreg=res.getString("codPregunta");
                res.close();

                consulta ="INSERT INTO DOCUMENTACION_PREGUNTAS(COD_DOCUMENTO, COD_PREGUNTA,"+
                        " DESCRIPCION_PREGUNTA, FECHA_CREACION, COD_ESTADO_REGISTRO,"+
                        " COD_TIPO_DOCUMENTACION_PREGUNTA, PREGUNTA_CERRADA)"+
                        " VALUES ('"+codDocumento+"','"+codPreg+"','"+descripcionPregunta+"'," +
                        "'"+sdf.format(new Date())+"',1,"+
                        "'"+codTipoPregunta+"','"+esRespuesta+"')" ;
                System.out.println("consulta" + consulta);
                if(st.executeUpdate(consulta)>0)System.out.println("se registro el tipo de documentacion pregunta");
                
                
                  
                }

                if(!descripcionRespueta.equals("")){



                     PreparedStatement pst=con.prepareStatement("");
                     if(pst.executeUpdate()>0)System.out.println("se eliminaron respuestas anteriores");

                          consulta="INSERT INTO DOCUMENTACION_RESPUESTAS(COD_DOCUMENTO, COD_PREGUNTA, COD_RESPUESTA,"+
                                   " DESCRIPCION_RESPUESTA, COD_ESTADO_REGISTRO, RESPUESTA)"+
                                   " VALUES ('"+codDocumento+"','"+codPreg+"'," +
                                   "(select isnull(max(cod_respuesta),0) from documentacion_respuestas where cod_documento = '"+codDocumento+"' and cod_pregunta = '"+codPreg+"'),'"+descripcionRespueta+"','1','"+esRespuesta+"')";
                          System.out.println("consulta insert respuesta "+consulta);
                          pst=con.prepareStatement(consulta);
                          if(pst.executeUpdate()>0)System.out.println("se inserto la respuesta");




                    }
                

                

                //Cell celdaCredito=hoja.getCell(7,i);
                //creditoDeposito=celdaCredito.getContents();
                //System.out.println("creditoDeposito "+creditoDeposito);

//                if(posicionSaldo>=0){
//                Cell celdaSaldo=hoja.getCell(posicionSaldo,i);
//                if(celdaSaldo.getType()==CellType.NUMBER){
//                    NumberCell nc = (NumberCell) celdaSaldo;
//                    saldoDeposito = nc.getValue();
//                }else{
//                    saldoDeposito=0.0;
//                }
//                System.out.println("saldoDeposito"+ saldoDeposito);
//                }
//
//
//                //Cell celdaSaldo=hoja.getCell(8,i);
//                //saldoDeposito=celdaSaldo.getContents();
//                //System.out.println("saldoDeposito "+saldoDeposito);
//
//
//                // insercion de los registros
//                //
//
//                //String codTerritorio = this.buscaCodigoTerritorio(con,agenciaDeposito);
//                //String codTipoDeposito = this.buscaCodigoTipoDeposito(con, descripcionDeposito);
//
//                //if(!codTerritorio.equals("") && !codTipoDeposito.equals("")){
//                //!agencia.equals("")&& !tipoDeposito.equals("") &&
//                  if(debitoDeposito>=0.0 && creditoDeposito>=0.0){
//
//                     consulta ="INSERT INTO    dbo.INGRESOS_DEPOSITO_DETALLE (COD_INGRESO_DEPOSITO,COD_INGRESO_DEPOSITO_DETALLE ,  FECHA_DEPOSITO,   AGENCIA,   TIPO_DEPOSITO,   REFERENCIA,   ITF,   DEBITO,   CREDITO,   SALDO    )  " +
//                             " VALUES ("+codIngresoDeposito+",(select isnull(max(COD_INGRESO_DEPOSITO_DETALLE),0)+1 from INGRESOS_DEPOSITO_DETALLE) , " +
//                             " '"+fechaDeposito+"', '"+agencia+"','"+tipoDeposito+"' , '"+referenciaDeposito+"', '"+itfDeposito+"','"+debitoDeposito+"','"+creditoDeposito+"','"+saldoDeposito+"' );";
//
//                     System.out.println("consulta" + consulta);
//                     st = con.createStatement();
//                     st.executeUpdate(consulta);
//                   }
                //}
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
