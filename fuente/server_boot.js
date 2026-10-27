async function startAuthenticatedApp(){
  try{
    const current=await apiRequest("/api/session");
    databaseCsrf=current.csrf;
    if(current.authenticated){
      document.getElementById("login").hidden=true;
      document.getElementById("app").hidden=false;
      await boot();
    }
  }catch(error){
    document.getElementById("loginError").textContent="No se pudo conectar con la base de datos: "+error.message;
  }
}

document.getElementById("loginForm").addEventListener("submit",async event=>{
  event.preventDefault();
  const errorNode=document.getElementById("loginError");
  errorNode.textContent="";
  try{
    const result=await apiRequest("/api/login",{
      method:"POST",
      body:JSON.stringify({
        username:document.getElementById("loginUser").value,
        password:document.getElementById("loginPassword").value
      })
    });
    databaseCsrf=result.csrf;
    document.getElementById("login").hidden=true;
    document.getElementById("app").hidden=false;
    await boot();
  }catch(error){
    errorNode.textContent=error.message;
  }
});

startAuthenticatedApp();
