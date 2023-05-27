use async_tungstenite::tokio::accept_async;
use async_tungstenite::tungstenite::Message;
use futures::prelude::*;
use tokio::{self, net};
#[tokio::main]
async fn main() {
    let tcp = net::TcpListener::bind("127.0.0.1:9991")
        .await
        .expect("Error binding to port");

    let frontend = loop {
        match tcp.accept().await {
            Ok((stream, addr)) => {
                println!("New connection! {}", addr);
                break stream;
            }
            Err(err) => {
                eprintln!("Error accepting client {}", err)
            }
        }
    };

    let ws = accept_async(frontend).await.unwrap();

    let (mut write, mut reader) = ws.split();
    tokio::task::spawn(async move {
        let mut i = 1;
        loop {
            write.send(Message::Text(format!("{}", i))).await.unwrap();

            i += 1;
            tokio::time::sleep(tokio::time::Duration::from_secs_f32(0.5)).await;
        }
    });
    while let Some(e) = reader.next().await {
        println!("New message: {}", e.unwrap());
    }
}
