package formasFarmaceuticasLote;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
                
                function getCodigoReactivo(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraDetalleMPReactivos/navegador_formula_maestraMP.jsf?codigo='+codigo;
                }
                
                function getCodigo(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraDetalleMP/navegador_formula_maestraMP.jsf?codigo='+codigo;
                }
                function getCodigoActividad(codigo){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigo;
                }
                function getCodigoActividadProduccion(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoActividadMicrobiologia(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoActividadControlDeCalidad(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoActividadAcondicionamiento(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoFasePreparado(codigoFormulaMaestra){
                //   alert(codigo);
                   location='../formulaMaestraPreparado/navegadorFormulaMaestraPreparado.jsf?codigoFormulaMaestra='+codigoFormulaMaestra;
                }
                function getCodigoArea(codigo){
                //   alert(codigo);
                   location='../formulaMaestraEP/navegador_formula_maestraEP.jsf?codigo='+codigo;
                }
                function getCodigoES(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraES/navegador_formula_maestraES.jsf?codigo='+codigo;
                }
                function getCodigoMatProm(codigo){
                //   alert(codigo);
                   location='../formulaMaestraDetalleMPROM/navegador_formula_maestraMPROM.jsf?codigo='+codigo;
                }
                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }          
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            /*var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }*/
                            /*if(count1==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }*/
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }                
                
                                            </script>
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">
                    <h:outputText value="#{ManagedFormasFarmLote.cargarFormasFarmLote}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Codigo de Formas Farmaceuticas por Lote" />
                    <rich:dataTable value="#{ManagedFormasFarmLote.formasFarmLoteList}" var="data" id="dataFormasFarmLote"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Forma Farmaceutica"  />
                            </f:facet>
                            <h:outputText value="#{data.formasFarmaceuticas.nombreForma}"  title="Forma Farmaceutica" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cod Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.codLote}" title="Cantidad del Lote" />
                        </h:column>
                    </rich:dataTable>
                    
                    <br>
                    <input type="button" value="agregar" class="btn" onclick="location='agregarFormasFarmLote.jsf'" />
                    <h:commandButton value="Editar" type="submit"   styleClass="btn"  action="#{ManagedFormasFarmLote.editarFormasFarmLote_action}" onclick="return editarItem('form1:dataFormasFarmLote');"/>
                    <h:commandButton value="Eliminar" type="submit"  styleClass="btn"  action="#{ManagedFormasFarmLote.eliminarFormasFarmLote_action}"  onclick="return eliminar('form1:dataFormasFarmLote');"/>
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestra.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

