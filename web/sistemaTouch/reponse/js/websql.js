/*
 *hojas auxiliares guardadas
 * 1-limpieza
 * 2-repesaje
 * 3-lavado
 *
*/
function nuevoAjax()
{	var xmlhttp=false;
    try {
        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            xmlhttp = false;
        }
    }
    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
        xmlhttp = new XMLHttpRequest();
    }

    return xmlhttp;
}
function subirInformacion(celda,codLote,codProgProd,codHoja,peticion)
{
    document.getElementById('formsuper').style.visibility='visible';
    document.getElementById('divImagen').style.visibility='visible';
    if(confirm('Esta seguro de subir la informacion?\nSe sobreescribira la informacion de la hoja si la hubiera'))
    {
        var ajax=nuevoAjax();
        ajax.open("GET",peticion,true);
        ajax.onreadystatechange=function(){
        if (ajax.readyState==4) {
            if(ajax.responseText==null || ajax.responseText=='')
            {
                alert('No se puede conectar con el servidor, verifique su conexión a internet');
                document.getElementById('formsuper').style.visibility='hidden';
                document.getElementById('divImagen').style.visibility='hidden';
                return false;
            }
            if(parseInt(ajax.responseText.split("\n").join(""))=='1')
            {
                sqlConnection.eliminarDespuesDeGuardar(codLote,codProgProd,codHoja);
                alert('Se subio correctamente la informacion');
                document.getElementById('formsuper').style.visibility='hidden';
                document.getElementById('divImagen').style.visibility='hidden';
                return true;
            }
            else
            {
                alert(ajax.responseText.split("\n").join(""));
                document.getElementById('formsuper').style.visibility='hidden';
                document.getElementById('divImagen').style.visibility='hidden';
                return false;
            }
        }
    }

    ajax.send(null);
    }
    else
    {
        alert('Ni modo');
    }
}

var sqlConnection = (function() {
              var db;
              var dataPendientes;
              var contPendientes=0;
              if (window.openDatabase) {
                    db = openDatabase("DBSISTEMAS_NO_BORRAR", "1.0", "HTML5 Database API example", 4*1024*1024);
              }
              function onError(tx, error) {
                alert(error.message)
              }
              function addRegistroPendienteOrdenManufactura(codProgProd,codLote,codHoja,url)
              {
                var row = dataPendientes.insertRow(dataPendientes.rows.length);
                
                var cell0 = row.insertCell(0);
                cell0.className="tableCell";
                var element0 = document.createElement("span");
                element0.className='textHeaderClassBody';
                element0.innerHTML=dataPendientes.rows.length-1;
                cell0.appendChild(element0);

                var cell1 = row.insertCell(1);
                cell1.className="tableCell";
                var element1 = document.createElement("span");
                element1.className='textHeaderClassBody';
                element1.innerHTML=codLote;
                cell1.appendChild(element1);
                var elementId=document.createElement("input");
                elementId.type='hidden';
                elementId.value=codProgProd;
                cell1.appendChild(elementId);
                var innerHTMLHoja="";
                switch(parseInt(codHoja))
                {
                    case 1:
                        innerHTMLHoja="<img src='../../../img/limpieza.gif' alt='Limpieza'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>LIMPIEZA</span>";
                        break;
                    case 2:
                        innerHTMLHoja="<img src='../../reponse/img/repesada.jpg' alt='Repesada'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>REPESADA</span>";
                        break;
                    case 3:
                        innerHTMLHoja="<img src='../../../img/lavado.gif' alt='Lavado'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>LAVADO</span>";
                        break;
                    case 4:
                        innerHTMLHoja="<img src='../../../img/despirogenizado.gif' alt='Despirogenizado'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>DESPIROGENIZADO</span>";
                        break;
                    case 5:
                        innerHTMLHoja="<img src='../../../img/lavado.gif' alt='Lavado'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>LAVADO</span>";
                        break;
                    case 6:
                        innerHTMLHoja="<img src='../../../img/dosificado.gif' alt='Lavado'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>DOSIFICADO</span>";
                        break;
                    case 7:
                        innerHTMLHoja="<img src='../../../img/despeje.gif' alt='Despeje de Linea'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>DESPEJE DE LINEA</span>";
                        break;
                    case 8:
                        innerHTMLHoja="<img src='../../../img/controllenado.gif' alt='Control Llenado'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>CONTROL LLENADO VOLUMEN</span>";
                        break;
                    case 9:
                        innerHTMLHoja="<img src='../../../img/controlDosificado.gif' alt='C'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>CONTROL DOSIFICADO</span>";
                        break;
                    case 10:
                        innerHTMLHoja="<img src='../../../img/rendimiento.gif' alt='Rendimiento Dosificado'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>RENDIMIENTO DOSIFICADO</span>";
                        break;
                    case 11:
                        innerHTMLHoja="<img src='../../../img/esterilizacion.gif' alt='Esterilizacion Calor Humedo'><span class='textHeaderClassBody' style='margin-left:3px;font-weight:normal'>ESTERILIZACION CALOR HUMEDO</span>";
                        break;
                    default:
                        innerHTMLHoja="Error";
                        break;
                }
                var cell2 = row.insertCell(2);
                cell2.align='center';
                cell2.className="tableCell";
                cell2.innerHTML=innerHTMLHoja;

                var cell3 = row.insertCell(3);
                cell3.align='center';
                cell3.className="tableCell";
                var element3=document.createElement("a");
                element3.innerHTML="<img src='../../reponse/img/subir.gif' alt='subir informacion'>";
                element3.onclick=function(){subirInformacion(this,codLote,codProgProd,codHoja,url);};
                cell3.appendChild(element3);


                var cell4 = row.insertCell(4);
                cell4.align='center';
                cell4.className="tableCell";
                var element4=document.createElement("a");
                element4.innerHTML="<img src='../../../img/menos.png' alt='subir informacion'>";
                element4.onclick=function(){descartarRegistroAuxiliar(codLote,codProgProd,codHoja);};
                cell4.appendChild(element4);

              }
              
              function verificarRegistroPendiente(codProgramaProd,codLote,codHoja){
                  var cont=0;
                  if (navigator.userAgent.indexOf('Chrome') !=-1)
                  {
                      db.transaction(function(tx) {
                      tx.executeSql("SELECT COD_PROGRAMA_PROD FROM DATOS_NO_GUARDADOS where COD_PROGRAMA_PROD = ? and COD_LOTE = ? AND COD_HOJA=?",[codProgramaProd,codLote,codHoja]// ", [codProgramaProd,codLote,codHoja]
                      , function(tx, result) {
                          if(parseInt(result.rows.length)>0)
                              {
                                  var  panelRegistro=document.createElement("div");
                                  panelRegistro.className='panelModalVisible';
                                  var innerHTML="<center><table class='tablaRegistro' cellpadding='0px' cellspacing='0px'><tr><td class='tableHeaderClass'><span class='textHeaderClass'>REGISTROS PENDIENTES</span></td></tr>"+
                                      "<tr><td class='tableCell'>Subiendo registros pendientes anteriores<span></span></td></tr>"+
                                      "<tr><td class='tableCell' align='center'><img src='../../reponse/img/load.gif'/></td></tr></table></center>";
                                  panelRegistro.innerHTML=innerHTML;
                                  document.body.appendChild(panelRegistro);
                                  //window.close();
                                  return false;
                              }

                      },onerror);
                    });
                  }
                return true;
              }
              function mostrarDatosPendientesRegistro() {
                db.transaction(function(tx) {
                    console.log('inicioPisco');
                
                dataPendientes=document.getElementById("dataPendientes");
                dataPendientes.innerHTML="<tr><td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>&nbsp;</span></td>"+
                                         " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>LOTE</span></td>"+
                                         " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Hoja</span></td>"+
                                         " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Subir</span></td>"+
                                        " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass'>Desechar</span></td></tr>";
                                    console.log('antes piscos');
                  tx.executeSql("SELECT * FROM DATOS_NO_GUARDADOS order by COD_LOTE,COD_HOJA", [], function(tx, result) {
                    for (var i = 0, item = null; i < result.rows.length; i++) {
                        console.log('espues piscos');
                      item = result.rows.item(i);
                      addRegistroPendienteOrdenManufactura(item['COD_PROGRAMA_PROD'],item['COD_LOTE'],item['COD_HOJA'],item['URL_PETICION']);
                    }
                  });
                });
              }

              function crearTabla() {
                  if (navigator.userAgent.indexOf('Chrome') !=-1)
                  {
                    db.transaction(function(tx) {
                      tx.executeSql("CREATE TABLE DATOS_USUARIO (COD_PERSONAL,COD_AREA)",[],
                          function(tx) {console.log('Se creo la tabla DATOS USUARIO'); },
                          console.log('tabla existente no se creo datos usuario'));
                    });
                    db.transaction(function(tx) {
                      tx.executeSql("CREATE TABLE DATOS_NO_GUARDADOS (COD_PROGRAMA_PROD,COD_LOTE,COD_HOJA,URL_PETICION)",[],
                          function(tx) {console.log('Se creo la tabla sistemas'); },
                          console.log('tabla existente no se creo tabla sistemas'));
                    });
                    
                  }
                  else
                  {
                        alert('La funcion de guardado local no esta disponible para firefox');
                  }
              }
              function iniciarSessionUsuario(COD_PERSONAL,COD_AREA_EMPRESA,ONCOMPLETE)
              {
                    db.transaction(function(tx) {
                      tx.executeSql("INSERT INTO DATOS_USUARIO (COD_PERSONAL,COD_AREA) VALUES (?,?)",[COD_PERSONAL,COD_AREA_EMPRESA],
                            function(){ONCOMPLETE();}
                          ,
                          onError);
                    });

              }
              function terminarSessionUsuario(ONCOMPLETE)
              {
                  db.transaction(function(tx) {
                      tx.executeSql("DELETE FROM DATOS_USUARIO",[],ONCOMPLETE, onError);
                    });
              }
              function verificarUsuarioLogin(ONTRUE,ONFALSE) {
                db.transaction(function(tx) {
                    tx.executeSql("SELECT * FROM DATOS_USUARIO ", [], function(tx, result) {
                        if(result.rows.length>0)
                        {
                            if(ONTRUE!=null)
                                {

                                    ONTRUE();
                                }
                        }
                        else
                        {
                            if(ONFALSE!=null)
                                {
                                    ONFALSE();
                                }
                        }
                  });
                });
                
              }
              function insertarRegistroAuxiliar(COD_PROGRAMA_PROD,COD_LOTE,COD_HOJA,URL_DIRECCION,ONCOMPLETE) {

                
                     db.transaction(function(tx) {
                      tx.executeSql("INSERT INTO DATOS_NO_GUARDADOS (COD_PROGRAMA_PROD,COD_LOTE,COD_HOJA,URL_PETICION) VALUES (?,?,?,?)",[COD_PROGRAMA_PROD,
                          COD_LOTE,COD_HOJA,URL_DIRECCION],
                            function(){alert('Se guardo el registro en la memoria local.\n Recuerde no tener muchos lotes pendiente de guardar');ONCOMPLETE();}
                          ,
                          onError);
                    });
                
              }
              function eliminarDespuesDeGuardar(COD_LOTE,COD_PROGRAMA_PROD,COD_HOJA)
              {
                  db.transaction(function(tx) {
                  tx.executeSql("DELETE FROM DATOS_NO_GUARDADOS WHERE COD_LOTE=? AND  COD_PROGRAMA_PROD = ? AND COD_HOJA=?", [COD_LOTE, COD_PROGRAMA_PROD,COD_HOJA],function(){console.log('eliminando despues de guardar en oficial');mostrarDatosPendientesRegistro();}, onError);
                });
              }
              function descartarRegistroAuxiliar(COD_LOTE,COD_PROGRAMA_PROD,COD_HOJA)
              {
                  db.transaction(function(tx) {
                  tx.executeSql("DELETE FROM DATOS_NO_GUARDADOS WHERE COD_LOTE=? AND  COD_PROGRAMA_PROD = ? AND COD_HOJA=?", [COD_LOTE, COD_PROGRAMA_PROD,COD_HOJA],function(){alert('Se descarto el registro');mostrarDatosPendientesRegistro();}, onError);
                });
              }
              function updateRecord(id, textEl) {
                db.transaction(function(tx) {
                  tx.executeSql("UPDATE Table1Test SET text = ? WHERE id = ?", [textEl.innerHTML, id], null, onError);
                });
              }

              
              function dropTable() {
                db.transaction(function(tx) {
                  tx.executeSql("DROP TABLE DATOS_NO_GUARDADOS", [],
                      function(tx) { alert('cdcd'); },
                      onError);
                });
              }

              return {
                crearTabla: crearTabla,
                terminarSessionUsuario:terminarSessionUsuario,
                verificarUsuarioLogin:verificarUsuarioLogin,
                iniciarSessionUsuario:iniciarSessionUsuario,
                insertarRegistroAuxiliar:insertarRegistroAuxiliar,
                dropTable:dropTable,
                mostrarDatosPendientesRegistro:mostrarDatosPendientesRegistro,
                eliminarDespuesDeGuardar:eliminarDespuesDeGuardar,
                verificarRegistroPendiente:verificarRegistroPendiente
              }
            })();


