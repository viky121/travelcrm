"""alter db

Revision ID: 32a44fa5e09f
Revises: 2ad1be7305c3
Create Date: 2014-10-01 20:11:12.845570

"""

# revision identifiers, used by Alembic.
revision = '32a44fa5e09f'
down_revision = '2ad1be7305c3'

from alembic import op
import sqlalchemy as sa


def upgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('outgoing', 'date')
    ### end Alembic commands ###


def downgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.add_column('outgoing', sa.Column('date', sa.DATE(), autoincrement=False, nullable=False))
    ### end Alembic commands ###