// channel -> DDR adapter definition
#define CHANNEL_TO_DDR_NAME(channel) "channel_to_ddr_" channel
#define CHANNEL_TO_DDR(type,channel) \
kernel void channel_to_ddr_##channel (global type* ptr) { \
  int offset = 0; \
  while (1) { ptr[offset++] = read_channel_altera (channel); } \
}

// DDR -> channel adapter definition
#define DDR_TO_CHANNEL_NAME(channel) "ddr_to_channel_" channel
#define DDR_TO_CHANNEL(type,channel) \
kernel void ddr_to_channel_##channel (global type* ptr) { \
  int offset = 0; \
  while (1) { write_channel_altera (channel, ptr[offset++]); } \
}


// Channel tee
#define TEE_NAME(channel1,channel2,channel3) "tee_" channel1 "_" channel2 "_" channel3
#define TEE(type,channel1,channel2,channel3) \
kernel void tee_##channel_##channel2_##channel2 (void) { \
  while (1) { \
    type value = read_channel_altera (channel); \
    write_channel_altera (channel2, value); \
    write_channel_altera (channel3, value); \
  } \
}

// Channel tee, with one branch going to DDR.
#define TEE_TO_DDR_NAME(channel1,channel2) "tee_to_ddr_" channel "_" channel2
#define TEE_TO_DDR(type,channel1,channel2) \
kernel void tee_to_ddr_##channel_##channel2 (global type* ptr) { \
  int offset = 0;\
  while (1) { \
    type value = read_channel_altera (channel); \
    ptr[offset++] = value; \
    write_channel_altera (channel2, value); \
  } \
}

