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
                function getCodigo(cod_maquina,codigo){
                 //  alert(codigo);
                   location='../partes_maquinaria/navegador_partes_maquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
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
                
                            var count=0;
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

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            if(confirm("esta seguro de Eliminar?")){
                             return true;
                            }else{
                                return false;
                            }
                }
           }                

        function verManteminiento(cod_maquina,codigo){                 
                   location='../frecuenciaMantenimientoMaquinaria/navegadorFrecuenciaMantenimientoMaquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
        }
       </script>
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">
                    <h:outputText value="#{ManagedMantenimientoMaquina.cargarMantenimientoMaquinas}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Mantenimiento de Maquinarias" />
                    <br> <br>
                    <rich:dataTable value="#{ManagedMantenimientoMaquina.mantenimientoMaquinaList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Programa Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.programaProduccionPeriodo.nombreProgramaProduccion}"  title="Programa Produccion" />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Mantenimiento"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposMantenimiento.nombreTipoMantenimiento}"  title="Tipo Mantenimiento" />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Maquinaria"  />
                            </f:facet>
                            <h:outputText value="#{data.maquinaria.nombreMaquina}" title="Nombre Maquinaria" />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Registro"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaRegistro}" title="Fecha Registro" >
                                <f:convertDateTime locale="en" pattern="dd/MM/yyyy" />
                            </h:outputText>
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Horas Frecuencia"  />
                            </f:facet>                            
                            <h:outputText value="#{data.frecuenciasMantenimientoMaquina.horasFrecuencia}" title="Horas Frecuencia" />                                                        
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Periodo"  />
                            </f:facet>                            
                            <h:outputText value="#{data.frecuenciasMantenimientoMaquina.tiposPeriodo.nombreTipoPeriodo}" title="Horas Frecuencia" />
                        </h:column>


                        
                    </rich:dataTable>
                    <%-- <ws:datascroller fordatatable="dataAreasEmpresa"  />--%>
                    <br>
                    <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedMantenimientoMaquina.agregarMantenimientoMaquina_action}"/>
                    <h:commandButton value="Editar"    styleClass="btn"  action="#{ManagedMantenimientoMaquina.editarMantenimientoMaquina_action}" onclick="return editarItem('form1:dataFormula');"/>
                    <h:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedMantenimientoMaquina.eliminarMantenimientoMaquina_action}"  onclick="return eliminar('form1:dataFormula');"/>
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedMaquinaria.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

