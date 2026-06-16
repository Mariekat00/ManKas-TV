import { ChannelDetail } from "@/components/channels/ChannelDetail";

type ChannelPageProps = {
  params: Promise<{
    id: string;
  }>;
};

export default async function ChannelPage({ params }: ChannelPageProps) {
  const { id } = await params;

  return <ChannelDetail channelId={id} />;
}
