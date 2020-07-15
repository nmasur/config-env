use anyhow::{Context, Result};
use rusoto_core::{
    credential::{AwsCredentials, ChainProvider, ProvideAwsCredentials},
    region::Region,
    signature::SignedRequest,
};
use std::env;
use std::time::Duration;

#[tokio::main]
async fn main() -> Result<()> {
    let application = env::var("APPLICATION").context("Variable APPLICATION missing.")?;
    let environment = env::var("ENVIRONMENT").context("Variable ENVIRONMENT missing.")?;
    let version = env::var("VERSION").context("Variable VERSION missing.")?;

    let creds: AwsCredentials = ChainProvider::new().credentials().await?;
    let request_url = sign_request(&creds, &application, &environment, &version);
    let config = reqwest::get(&request_url).await?.text().await?;
    for line in config.split('\n') {
        println!("export {}", line);
    }

    Ok(())
}

fn sign_request(
    creds: &AwsCredentials,
    application: &str,
    environment: &str,
    version: &str,
) -> String {
    let mut signer: SignedRequest = SignedRequest::new(
        "GET",
        "execute-api",
        &Region::UsEast1,
        &format!("/config/{}/{}/{}", application, environment, version),
    );
    signer.set_hostname(Some("config.d2dragon.net".to_string()));
    signer.add_param("ignore", "");
    signer.generate_presigned_url(creds, &Duration::new(60, 0), true)
}
