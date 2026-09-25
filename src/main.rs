use std::io::Read;
use std::net::TcpListener;

#[cfg(target_os = "hermit")]
use hermit as _;

// demo program to test the tcp interface
//

fn main() {
	let listener = TcpListener::bind("0.0.0.0:9975").unwrap();
	let (mut socket, _) = listener.accept().unwrap();
	let mut buf = [0u8; 1024];
	loop {
	    //println!("about to read");
		match socket.read(&mut buf) {
			Err(e) => {
				println!("Socker read error {e:?}");
				break;
			}
			Ok(received) => {
				//println!("Received: '{}'", std::str::from_utf8(&buf[..received]).unwrap());
				print!("{}", std::str::from_utf8(&buf[..received]).unwrap());
				if received == 0 {
					break;
				}
			}
		}
	}
}
