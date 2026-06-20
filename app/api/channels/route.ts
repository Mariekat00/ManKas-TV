import { NextResponse } from "next/server";
import type { Channel } from "@/types";

const guaranteedChannels: Channel[] = [
  { id: "rmtv", name: "Real Madrid TV", logo: "https://upload.wikimedia.org/wikipedia/en/thumb/1/12/Real_Madrid_CF.svg/512px-Real_Madrid_CF.svg.png", stream_url: "https://rmtv.akamaized.net/hls/live/2043153/rmtv-es-web/master.m3u8", category: "Sports", country: "Spain", language: "Spanish", created_at: "" },
  { id: "gol-classics", name: "Gol Classics", logo: "https://img.icons8.com/fluency/512/soccer.png", stream_url: "https://d71gqtnep83vb.cloudfront.net/gol_classics/gol_classics.m3u8", category: "Sports", country: "Spain", language: "Spanish", created_at: "" },
  { id: "lequipe", name: "L'Equipe", logo: "", stream_url: "https://www.dailymotion.com/video/x2lefik", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "equidia", name: "Equidia", logo: "", stream_url: "https://raw.githubusercontent.com/Paradise-91/ParaTV/main/streams/equidia/live2.m3u8", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "trace-sport-stars", name: "Trace Sport Stars", logo: "", stream_url: "https://lightning-tracesport-samsungau.amagi.tv/playlist.m3u8", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "ftf-sports", name: "FTF Sports", logo: "", stream_url: "https://1657061170.rsc.cdn77.org/HLS/FTF-LINEAR.m3u8", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "telemundo-ny", name: "Telemundo NY", logo: "", stream_url: "https://nbculocallive.akamaized.net/hls/live/2037083/newyork/stream7/master.m3u8", category: "Sports", country: "USA", language: "Spanish", created_at: "" },
  { id: "arryadia", name: "Arryadia", logo: "", stream_url: "https://stream-lb.livemediama.com/arryadia/hls/master.m3u8", category: "Sports", country: "Morocco", language: "Arabic", created_at: "" },
  { id: "arryadia-hd1", name: "Arryadia HD1", logo: "", stream_url: "https://stream-lb.livemediama.com/arryadia-hd-01/hls/master.m3u8", category: "Sports", country: "Morocco", language: "Arabic", created_at: "" },
  { id: "bein-xtra", name: "beIN Sports XTRA", logo: "", stream_url: "https://bein-xtra-bein.amagi.tv/playlist.m3u8", category: "Sports", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "bein-xtra-es", name: "beIN Sports XTRA Español", logo: "", stream_url: "https://dc1644a9jazgj.cloudfront.net/beIN_Sports_Xtra_Espanol.m3u8", category: "Sports", country: "USA", language: "Spanish", created_at: "" },
  { id: "bein-sports-1", name: "beIN Sports 1", logo: "", stream_url: "http://23.237.104.106:8080/USA_BEIN/index.m3u8", category: "Sports", country: "USA", language: "English", created_at: "" },
  { id: "30a-golf", name: "30A Golf Kingdom", logo: "", stream_url: "https://30a-tv.com/feeds/vidaa/golf.m3u8", category: "Sports", country: "USA", language: "English", created_at: "" },
  { id: "as3-sport", name: "AS3 Sport TV", logo: "", stream_url: "https://streamtv.as3sport.online:3394/hybrid/play.m3u8", category: "Sports", country: "International", language: "English", created_at: "" },
  { id: "bahrain-sports-1", name: "Bahrain Sports 1", logo: "", stream_url: "https://5c7b683162943.streamlock.net/live/ngrp:sportsone_all/playlist.m3u8", category: "Sports", country: "Bahrain", language: "Arabic", created_at: "" },
  { id: "cricket-gold", name: "Cricket Gold", logo: "", stream_url: "https://streams2.sofast.tv/scheduler/scheduleMaster/418.m3u8", category: "Sports", country: "India", language: "English", created_at: "" },
  { id: "draftkings", name: "DraftKings Network", logo: "", stream_url: "https://na.linear.zype.com/e0bd0e23-a958-4e43-8164-4f2fef8876a8/fd3614bd-90bf-4530-a277-65ae3a1720c8-zype/live.m3u8", category: "Sports", country: "USA", language: "English", created_at: "" },
  { id: "cazetv", name: "CazéTV", logo: "", stream_url: "https://www.youtube.com/@cazetvoficial/live", category: "Sports", country: "Brazil", language: "Portuguese", created_at: "" },
  { id: "alkass-one", name: "Alkass One", logo: "", stream_url: "https://liveeu-gcp.alkassdigital.net/alkass1-p/main.m3u8", category: "Sports", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "alkass-two", name: "Alkass Two", logo: "", stream_url: "https://liveeu-gcp.alkassdigital.net/alkass2-p/main.m3u8", category: "Sports", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "alkass-three", name: "Alkass Three", logo: "", stream_url: "https://liveeu-gcp.alkassdigital.net/alkass3-p/main.m3u8", category: "Sports", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "alkass-four", name: "Alkass Four", logo: "", stream_url: "https://liveeu-gcp.alkassdigital.net/alkass4-p/main.m3u8", category: "Sports", country: "Qatar", language: "Arabic", created_at: "" },
  { id: "bbc-one", name: "BBC One", logo: "", stream_url: "http://a.files.bbci.co.uk/media/live/manifesto/audio_video/simulcast/hls/uk/hls_tablet/ak/bbc_one_london.m3u8", category: "Sports", country: "UK", language: "English", created_at: "" },
  { id: "bbc-two", name: "BBC Two", logo: "", stream_url: "http://a.files.bbci.co.uk/media/live/manifesto/audio_video/simulcast/hls/uk/hls_tablet/ak/bbc_two_england.m3u8", category: "Sports", country: "UK", language: "English", created_at: "" },
  { id: "canal-sport", name: "Canal+ Sport", logo: "", stream_url: "http://151.80.18.177:86/Canal+_sport_HD/index.m3u8", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "canal-foot", name: "Canal+ Foot", logo: "", stream_url: "https://test.946985.filegear-sg.me/proxy/ef3174f16d4557d2", category: "Sports", country: "France", language: "French", created_at: "" },
  { id: "ard-erde", name: "ARD (Das Erste)", logo: "", stream_url: "https://daserste-live.ard-mcdn.de/daserste/live/hls/int/master.m3u8", category: "Sports", country: "Germany", language: "German", created_at: "" },
  { id: "telemundo-intl", name: "Telemundo Internacional", logo: "", stream_url: "http://138.121.15.230:9002/TELEMUNDO/index.m3u8", category: "Sports", country: "USA", language: "Spanish", created_at: "" },
  { id: "cctv-football", name: "CCTV Storm Football", logo: "", stream_url: "http://38.75.136.137:98/gslb/dsdqpub/fyzq.m3u8?auth=testpub", category: "Sports", country: "China", language: "Chinese", created_at: "" },
];

export async function GET() {
  return NextResponse.json({ channels: guaranteedChannels }, {
    headers: { "Cache-Control": "no-store" },
  });
}
