#include <stdio.h>
#include <cwiid.h>

void cwiid_callback(cwiid_wiimote_t *wiimote, int n, union cwiid_mesg mesg[], struct timespec *timestamp) {
	int i;
	printf("Callback called\n");
	for(i=0;i<n;++i) {
		if(mesg[i].type==CWIID_MESG_IR) {
			struct cwiid_ir_mesg *ir = (struct cwiid_ir_mesg *) &(mesg[i]);
			printf("%d:%d:%d:%d\n", ir->src->valid, ir->src->pos[0], ir->src->pos[1], ir->src->size);
		}
	}
}

int main(int argc, char **argv) {
	bdaddr_t addr=*BDADDR_ANY;
	cwiid_wiimote_t *mote=cwiid_open(&addr, CWIID_FLAG_CONTINUOUS|CWIID_FLAG_MESG_IFC);
	if(!mote) {
		printf("Couldn't connect\n");
		return -1;
	}
	printf("Connected\n");
	cwiid_enable(mote, CWIID_FLAG_CONTINUOUS);
	printf("enabled\n");
	cwiid_command(mote, CWIID_CMD_RPT_MODE, CWIID_RPT_IR);
	//cwiid_set_mesg_callback(mote, &cwiid_callback);
	printf("IR activated\n");
	int n,i,j;
	union cwiid_mesg *msgs;
	cwiid_set_led(mote, 12);
        struct timespec old_ts;
	while(1) {
		struct timespec ts;
		cwiid_get_mesg(mote, &n, &msgs, &ts);
		printf("time elapsed : %ld us\n",(ts.tv_nsec-old_ts.tv_nsec)/1000);
                old_ts = ts;
		for(i=0;i<n;++i) {
			if(msgs[i].type!=CWIID_MESG_IR)
				continue;
			for(j=0;j<4;++j) {
				printf("%d:%d:%d:%d\n",
					msgs[i].ir_mesg.src[j].valid,
					msgs[i].ir_mesg.src[j].pos[0],
					msgs[i].ir_mesg.src[j].pos[1],
					msgs[i].ir_mesg.src[j].size);
			}
			
		}
	}

}
