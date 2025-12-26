FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04-test

COPY run_ray.sh /run_ray.sh
RUN chmod +x /run_ray.sh

EXPOSE 8188
CMD ["/run_ray.sh"]

